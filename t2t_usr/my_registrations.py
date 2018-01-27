import os

from tensor2tensor.models import transformer
from tensor2tensor.utils import registry
from tensor2tensor.data_generators import problem

import tensor2tensor.data_generators.translate as translate

from tensor2tensor.data_generators import text_encoder, generator_utils

import tensorflow as tf

import re

FLAGS = tf.flags.FLAGS

# End-of-sentence marker.
EOS = text_encoder.EOS_ID
UNK = "__UNK__"

import logging

#logging.basicConfig(format='%(asctime)-15s [%(levelname)7s] %(funcName)s - %(message)s', level=logging.DEBUG)


class TranslateBase(translate.TranslateProblem):
	@property
	def is_character_level(self):
		return False

	@property
	def use_subword_tokenizer(self):
		return False

	@property
	def targeted_vocab_size(self):
		return 100000

	@property
	def vocab_file(self):
		return self.vocab_name
	
	# TODO: přesunout do otce
	def postprocess(self, text):
		return text

	@property
	def needs_postprocessing(self):
		return False

class TranslateDecsBase(TranslateBase):
	SRC_LANG = "de"
	TGT_LANG = "cs"

	@property
	def vocab_name(self):
		return "vocab.decs"

	@property
	def num_shards(self):
		return 1

	@property
	def input_space_id(self):
		return problem.SpaceID.DE_TOK

	@property
	def target_space_id(self):
		return problem.SpaceID.CS_TOK


class TranslateEncsBase(TranslateBase):
	SRC_LANG = "en"
	TGT_LANG = "cs"

	@property
	def vocab_name(self):
		return "vocab.encs"

	@property
	def num_shards(self):
		return 10

	@property
	def input_space_id(self):
		return problem.SpaceID.EN_TOK

	@property
	def target_space_id(self):
		return problem.SpaceID.CS_TOK

class TranslateOwnvocab(TranslateBase):

	@property
	def needs_postprocessing(self):
		return True

	def postprocessing(self, text):
		raise NotImplemented("implement postprocessing in derived class")

	def _create_vocab(self, input_files, vocab_filename):
		vocab = set() #set(['__UNK__'])
		for inp_f in input_files:
			with open(inp_f, "r", encoding="utf8") as f:
				for line in f:
					words = set(line.split())
					vocab.update(words)
		with open(vocab_filename, "w", encoding="utf8") as f:
			for w in sorted(list(vocab)):
				f.write(w+"\n")
		
	def _add_unk_to_vocab(self, vocab_data_path):
		with tf.gfile.GFile(vocab_data_path, mode="a") as f:
			f.write(UNK + "\n")	

	def feature_encoders(self, data_dir):
		vocab_filename = os.path.join(data_dir, self.vocab_file)
		encoder = text_encoder.TokenTextEncoder(vocab_filename, replace_oov=UNK)
		return {"inputs": encoder, "targets": encoder}

	def corpus(self, train):
		raise NotImplemented()
	
	def corpus_lang(self, train, lang):
		return self.corpus(train) % lang

	def generator(self, data_dir, tmp_dir, train):
		"""Instance of token generator for the WMT en->de task, training set."""
#		corpus = self.corpus(train)
#		corpus_path = os.path.join(tmp_dir, corpus)
#		print(corpus_path)
		vocab_path = os.path.join(tmp_dir, self.vocab_name)
		print(vocab_path)
		vocab_data_path = os.path.join(data_dir, self.vocab_name)
		corp_path_tgt = os.path.join(tmp_dir, self.corpus_lang(train, self.TGT_LANG))
		corp_path_src = os.path.join(tmp_dir, self.corpus_lang(train, self.SRC_LANG))
		if train:
			# create vocab here
			self._create_vocab([corp_path_tgt, corp_path_src], 
					   vocab_path)
			tf.gfile.Copy(vocab_path, vocab_data_path, overwrite=True)
			self._add_unk_to_vocab(vocab_data_path)  # Add UNK to the vocab.
		token_vocab = text_encoder.TokenTextEncoder(vocab_data_path, replace_oov=UNK)
		# opraveno
		return translate.token_generator(corp_path_src, corp_path_tgt, token_vocab, EOS)

class TranslateDecsOwnvocab(TranslateDecsBase, TranslateOwnvocab):
	pass

class TranslateEncsOwnvocab(TranslateEncsBase, TranslateOwnvocab):
	pass

class TranslateDecsAazzBase(TranslateDecsOwnvocab):
	def corpus_lang(self, train, lang=None):
		if train:
			p = "train"
		else:
			p = "dev"
		if lang == "de":
			z = "aa"
		else:
			z = "zz"
		return "%s.%s.%s.%s" % (z, p, lang, self.SPLIT)

	def postprocess(self, text):
		return re.sub("\$ \$","",text)

class TranslateDecsZzaaBase(TranslateDecsOwnvocab):
	def corpus_lang(self, train, lang=None):
		if train:
			p = "train"
		else:
			p = "dev"
		if lang == "de":
			z = "zz"
		else:
			z = "aa"
		return "%s.%s.%s.%s" % (z, p, lang, self.SPLIT)

	def postprocess(self, text):
		return re.sub(" @@ ","",text)

@registry.register_problem
class TranslateDecsBpezz(TranslateDecsOwnvocab):
	def corpus(self, train):
		return "zz.train.%s.bpe" if train else "zz.dev.%s.bpe"
	def postprocess(self, text):
		return re.sub("\$ \$","",text)

@registry.register_problem
class TranslateDecsBpedefzz(TranslateDecsOwnvocab):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.bpe50k" if train else "dev.de.bpe50k"
		return "zz.train.cs.bpe" if train else "zz.dev.cs.bpe"

	def postprocess(self, text):
		return re.sub("\$ \$","",text)

@registry.register_problem
class TranslateDecsBpedefzzFix(TranslateDecsBpedefzz):
	pass

@registry.register_problem
class TranslateDecsBpeaadef(TranslateDecsOwnvocab):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "aa.train.de.bpe" if train else "aa.dev.de.bpe"
		return "train.cs.bpe50k" if train else "dev.cs.bpe50k"

	def postprocess(self, text):
		return re.sub("@@ ","",text)
	

@registry.register_problem
class TranslateDecsBpeaadefFix(TranslateDecsBpeaadef):
	pass

@registry.register_problem
class TranslateDecsBpe50k(TranslateDecsOwnvocab):
	def corpus(self, train):
		return "train.%s.bpe50k" if train else "dev.%s.bpe50k"
	
	def postprocess(self, text):
		return re.sub("@@ ","",text)

@registry.register_problem
class TranslateDecsBpeShrd(TranslateDecsBpe50k):
	def corpus(self, train):
		return "train.%s.shrd_bpe100k" if train else "dev.%s.shrd_bpe100k"
	def postprocess(self, text):
		return re.sub("_ ", " ", re.sub("@@ ","",text))

@registry.register_problem
class TranslateDecsBpeShrdUnd(TranslateDecsBpe50k):
	def corpus(self, train):
		return "train.%s.shrd_und_bpe100k" if train else "dev.%s.shrd_und_bpe100k"
	def postprocess(self, text):
		return re.sub("_ ", " ", re.sub("@@ ","",text))

@registry.register_problem
class TranslateDecsBpeShrdUndAgain(TranslateDecsBpeShrdUnd):
	pass



@registry.register_problem
class TranslateDecsBpeShrdUndEndfix(TranslateDecsBpe50k):
	def corpus(self, train):
		return "train.%s.shrd_und_bpe_endfix100k" if train else "dev.%s.shrd_und_bpe_endfix100k"
	def postprocess(self, text):
		text = re.sub("_", "", re.sub("@@ ","",text))
		text = re.sub("&und;", "_", text)
		return text

@registry.register_problem
class TranslateDecsBpe50kaader(TranslateDecsOwnvocab):
	def corpus_lang(self, train, lang):
		if lang == "de":
			# TODO: dev místo train!!!!
			return "aa.train.de.bpe" if train else "aa.train.de.bpe"
		return "train.cs.der+bpe54k" if train else "dev.cs.der+bpe54k"
	
	def postprocess(self, text):
		return re.sub("@@ ","",text)

@registry.register_problem
class TranslateDecsBpe50kaaderzz(TranslateDecsOwnvocab):
	def corpus_lang(self, train, lang):
		if lang == "de":
			# TODO: dev místo train!!!!
			return "aa.train.de.bpe" if train else "aa.train.de.bpe"
		return "zz.train.cs.der+bpe37k" if train else "zz.dev.cs.der+bpe37k"
	
	def postprocess(self, text):
		return re.sub("\$ \$","",text)

@registry.register_problem
class TranslateDecsBpeUnd(TranslateDecsOwnvocab):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.und_bpe50k" if train else "dev.de.und_bpe50k"
		return "train.cs.und_bpe50k" if train else "dev.cs.und_bpe50k"
	
	def postprocess(self, text):
		return re.sub("_ ", " ", re.sub("@@ ","",text))

@registry.register_problem
class TranslateDecsBpeUndAgain(TranslateDecsBpeUnd):
	pass


# 
@registry.register_problem
class TranslateDecsBpeUndEndfix(TranslateDecsBpeUnd):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.und_bpe_endfix50k" if train else "dev.de.und_bpe_endfix50k"
		return "train.cs.und_bpe_endfix50k" if train else "dev.cs.und_bpe_endfix50k"
	def postprocess(self, text):
		text = re.sub("_", "", re.sub("@@ ","",text))
		text = re.sub("&und;", "_", text)
		return text




@registry.register_problem
class TranslateDecsBpeUndShrd(TranslateDecsOwnvocab):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.und_bpe50k" if train else "dev.de.und_bpe50k"
		return "train.cs.und_bpe50k" if train else "dev.cs.und_bpe50k"
	
	def postprocess(self, text):
		return re.sub("_ ", " ", re.sub("@@ ","",text))



@registry.register_problem
class TranslateDecsBpe(TranslateDecsBpe50k):
	pass

@registry.register_problem
class TranslateDecsBpeaa(TranslateDecsOwnvocab):
	def corpus(self, train):
		return "aa.train.%s.bpe" if train else "aa.dev.%s.bpe"
	def postprocess(self, text):
		return re.sub(" @@ ","",text)

@registry.register_problem
class TranslateDecsPmorfaa(TranslateDecsOwnvocab):
	def corpus(self, train):
		return "aa.train.%s.pmorf" if train else "aa.dev.%s.pmorf"

	def postprocess(self, text):
		return re.sub(" @@ ","",text)

@registry.register_problem
class TranslateDecsPmorfzz(TranslateDecsOwnvocab):
	def corpus(self, train):
		return "zz.train.%s.pmorf" if train else "zz.dev.%s.pmorf"

	def postprocess(self, text):
		return re.sub("\$ \$","",text)

@registry.register_problem
class TranslateDecsAazzpmorf(TranslateDecsAazzBase):
	SPLIT = "pmorf"	

@registry.register_problem
class TranslateDecsBpeaazz(TranslateDecsAazzBase):
	SPLIT = "bpe"	

@registry.register_problem
class TranslateDecsBpezzaa(TranslateDecsZzaaBase):
	SPLIT = "bpe"	

@registry.register_problem
class TranslateDecsDeraazz(TranslateDecsAazzBase):
	SPLIT = "bpe"	

class TranslateSubwords(TranslateBase):

	@property
	def use_subword_tokenizer(self):
		return True

#	def feature_encoders(self, data_dir):
#		vocab_filename = os.path.join(data_dir, self.vocab_file)
#		# pomůže replace_oov=None???
#		encoder = text_encoder.TokenTextEncoder(vocab_filename, replace_oov=None)
#		return {"inputs": encoder, "targets": encoder}

	@property
	def file_byte_budget(self):
		return 1e6

	def generate_vocab(self, data_dir, tmp_dir, vocab_filename, vocab_size,
				  sources):
		"""Generate a vocabulary from the datasets in sources."""
		def generate():
			tf.logging.info("Generating vocab from: %s", str(sources))
			for lang_file in sources:
				tf.logging.info("Reading file: %s" % lang_file)
				filepath = os.path.join(tmp_dir, lang_file)
		#
		#		# Extract from tar if needed.
		#		if not tf.gfile.Exists(filepath):
		#			read_type = "r:gz" if filename.endswith("tgz") else "r"
		#			with tarfile.open(compressed_file, read_type) as corpus_tar:
		#				corpus_tar.extractall(tmp_dir)
		#
		#		# For some datasets a second extraction is necessary.
		#		if lang_file.endswith(".gz"):
		#			new_filepath = os.path.join(tmp_dir, lang_file[:-3])
		#			if tf.gfile.Exists(new_filepath):
		#				tf.logging.info(
		#			"Subdirectory %s already exists, skipping unpacking" % filepath)
		#			else:
		#				tf.logging.info("Unpacking subdirectory %s" % filepath)
		#				gunzip_file(filepath, new_filepath)
		#			filepath = new_filepath

		# Use Tokenizer to count the word occurrences.
				with tf.gfile.GFile(filepath, mode="r") as source_file:
					file_byte_budget = self.file_byte_budget
					counter = 0
					countermax = int(source_file.size() / file_byte_budget / 2)
					for line in source_file:
						if counter < countermax:
							counter += 1
						else:
							if file_byte_budget <= 0:
								break
							line = line.strip()
							file_byte_budget -= len(line)
							counter = 0
							yield line
		return generator_utils.get_or_generate_vocab_inner(data_dir, vocab_filename, vocab_size,
							 generate())


	def corpus(self, train):
		return "train.%s.tok" if train else "dev.%s.tok"

	def corpus_lang(self, train, lang):
		return self.corpus(train) % lang

	def generator(self, data_dir, tmp_dir, train):
		print("jsme v subwords generatoru.....")
		vocab_path = os.path.join(tmp_dir, self.vocab_name)
		print(vocab_path)

		vocab_data_path = os.path.join(data_dir, self.vocab_name)

		corpus_src = os.path.join(tmp_dir, self.corpus_lang(train, self.SRC_LANG))
		corpus_tgt = os.path.join(tmp_dir, self.corpus_lang(train, self.TGT_LANG))

		symbolizer_vocab = self.generate_vocab(
		        data_dir, tmp_dir, self.vocab_file, self.targeted_vocab_size,
        		[self.corpus_lang(train, self.SRC_LANG), self.corpus_lang(train, self.TGT_LANG)])
		return translate.token_generator(corpus_src, corpus_tgt, symbolizer_vocab, EOS)


class TranslateDecsSubwords(TranslateDecsBase, TranslateSubwords):
	pass

@registry.register_problem
class TranslateDecsSubwords50k(TranslateDecsSubwords):
	pass

@registry.register_problem
class TranslateDecsSubwords100k(TranslateDecsSubwords):
	@property
	def file_byte_budget(self):
		return 10e6	

@registry.register_problem
class TranslateDecsSubwords100kFbb100m(TranslateDecsSubwords):
	@property
	def file_byte_budget(self):
		return 100e6	



######################################################

@registry.register_problem
class TranslateEncsBpe(TranslateEncsBase, TranslateOwnvocab):
	def corpus(self, train):
		return "train.en-cs.%s.bpe50k" if train else "dev.en-cs.%s.bpe50k"
	def postprocess(self, text):
		return re.sub("@@ ","",text)

# TODO: vymazat
@registry.register_problem
class Prob(TranslateEncsBpe):
	pass


class TranslateEncsSubwords(TranslateEncsBase, TranslateSubwords):
	def corpus(self, train):
		return "train.en-cs.%s.tok" if train else "dev.en-cs.%s.tok"

@registry.register_problem
class TranslateEncsSubwords50k(TranslateEncsSubwords):
	pass

@registry.register_problem
class TranslateEncsSubwords100k(TranslateEncsSubwords):
	@property
	def file_byte_budget(self):
		return 10e6	

@registry.register_problem
class TranslateEncsSubwords100kFbb100m(TranslateEncsSubwords):
	@property
	def file_byte_budget(self):
		return 100e6	

@registry.register_problem
class TranslateEncsSubwords97kFbb100m(TranslateEncsSubwords):
	@property
	def targeted_vocab_size(self):
		return 97000

	@property
	def file_byte_budget(self):
		return 100e6	



@registry.register_problem
class TranslateEncsSubwords100kFbb1000m(TranslateEncsSubwords):
	@property
	def file_byte_budget(self):
		return 1000e6	



if __name__ == "__main__":
#	t = TranslateEncsSubwords100k()
#	print(t.file_byte_budget)

	t = TranslateDecsBpeUndEndfix()

	v = "Pro_ další_ informace_ o_ novém_ postupu_ při_ žádosti_ o_ vízum_ na@@ vš@@ tiv@@ te_ následující_ web@@ ovou_ stránku_ h@@ tt@@ p_ :_ /_ /_ mexi@@ co@@ .@@ us@@ em@@ bas@@ sy@@ .@@ g@@ ov_ /_ bole@@ ti@@ nes_ /_ sp@@ 10@@ 1@@ 20@@ 1_ &und;_ Vi@@ s@@ as@@ -@@ FA@@ Q@@ s.@@ h@@ t@@ m@@ l_"
	print(t.postprocess(v))
