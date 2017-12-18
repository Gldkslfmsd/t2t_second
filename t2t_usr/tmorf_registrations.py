
from . import my_registrations as my

from tensor2tensor.utils import registry


@registry.register_problem
class TranslateDecsTmorfsubTmorfsub(my.TranslateDecsSubwords100kFbb100m):
	@property
	def needs_postprocessing(self):
		return True

	def postprocess(self, text):
		return re.sub("@@ ","",text)

	def corpus(self, train):
		return "train.en-cs.%s.tok" if train else "dev.en-cs.%s.tok"

	def corpus_lang(self, train, lang):
		if lang == "de":
			return "aa.train.de.bpe" if train else "aa.train.de.bpe"
		return "zz.train.cs.der+bpe37k" if train else "zz.dev.cs.der+bpe37k"
	
