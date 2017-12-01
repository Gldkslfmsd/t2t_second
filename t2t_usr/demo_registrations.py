
@registry.register_problem
class TranslateDecsBpe30k3(TranslateDecsBpe30k):
	pass



@registry.register_problem
class TranslateDecsBpe30k2(TranslateDecsBpe30k):

	@property
	def vocab_name(self):
		return "vocab.decs2"

	def _create_vocab(self, input_files, vocab_filename):
		vocab = set() #set(['__UNK__'])
		for inp_f in input_files:
			with open(inp_f, "r") as f:
				for line in f:
					words = set(line.split())
					vocab.update(words)
		with open(vocab_filename, "w") as f:
			for w in sorted(list(vocab)):
				print("'%s'" % w, file=f)

	def _add_unk_to_vocab(self, vocab_data_path):
		with tf.gfile.GFile(vocab_data_path, mode="a") as f:
			f.write("'%s'\n" % UNK)	



