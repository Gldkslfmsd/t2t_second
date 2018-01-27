
from . import my_registrations as my

from tensor2tensor.utils import registry
import re


class TranslateDecsTmorfsubTmorfsubBase(my.TranslateDecsSubwords100kFbb100m):

	@property
	def needs_postprocessing(self):
		return True

	def postprocess(self, text):
		return re.sub("@@ ","",text)

	def corpus(self, train):
		return "train.%s.tmorf" if train else "dev.%s.tmorf"

class TranslateEncsTmorfsubTmorfsubBase(my.TranslateEncsSubwords100kFbb100m):

	@property
	def needs_postprocessing(self):
		return True

	def postprocess(self, text):
		return re.sub("@@ ","",text)

	def corpus(self, train):
		return "train.%s.tmorf" if train else "dev.%s.tmorf"



@registry.register_problem
class TranslateDecsTmorfsubTmorfsub(TranslateDecsTmorfsubTmorfsubBase):
	pass

@registry.register_problem
class TranslateDecsTmorfsubDersub(TranslateDecsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.tmorf" if train else "dev.de.tmorf"
		return "train.cs.der" if train else "dev.cs.der"

@registry.register_problem
class TranslateDecsSubTmorfsub(TranslateDecsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.tok" if train else "dev.de.tok"
		return "train.cs.tmorf" if train else "dev.cs.tmorf"

@registry.register_problem
class TranslateDecsTmorfsubSub(TranslateDecsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.tmorf" if train else "dev.de.tmorf"
		return "train.cs.tok" if train else "dev.cs.tok"

@registry.register_problem
class TranslateDecsSubDersub(TranslateDecsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.tok" if train else "dev.de.tok"
		return "train.cs.der" if train else "dev.cs.der"

#########################################################################
# fix @@ in Subword+DeriNet combination and Subword+Tmorf combination
@registry.register_problem
class TranslateDecsSubDersubFix(TranslateDecsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.tok" if train else "dev.de.tok"
		return "train.cs.der-fix" if train else "dev.cs.der-fix"

	def postprocess(self, text):
		return re.sub("ŽŽŽ ","",text)

@registry.register_problem
class TranslateDecsSubTmorfsubFix(TranslateDecsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.tok" if train else "dev.de.tok"
		return "train.cs.tmorf-fix" if train else "dev.cs.tmorf-fix"

	def postprocess(self, text):
		return re.sub("ŽŽŽ ","",text)

@registry.register_problem
class TranslateDecsTmorfsubSubFix(TranslateDecsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.tmorf-fix" if train else "dev.de.tmorf-fix"
		return "train.cs.tok" if train else "dev.cs.tok"

	def postprocess(self, text):
		return text
#		return re.sub("ŽŽŽ ","",text)


@registry.register_problem
class TranslateDecsTmorfsubTmorfsubFix(TranslateDecsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.tmorf-fix" if train else "dev.de.tmorf-fix"
		return "train.cs.tmorf-fix" if train else "dev.cs.tmorf-fix"

	def postprocess(self, text):
		return re.sub("ŽŽŽ ","",text)


@registry.register_problem
class TranslateDecsTmorfsubDersubFix(TranslateDecsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "de":
			return "train.de.tmorf-fix" if train else "dev.de.tmorf-fix"
		return "train.cs.der-fix" if train else "dev.cs.der-fix"

	def postprocess(self, text):
		return re.sub("ŽŽŽ ","",text)


############################################################################
# encs

class TranslateEncsTmorfsubTmorfsubBase(my.TranslateEncsSubwords100kFbb100m):

	@property
	def needs_postprocessing(self):
		return True

	def postprocess(self, text):
		return re.sub("@@ ","",text)

	def corpus(self, train):
		return "train.en-cs.%s.tmorf" if train else "dev.en-cs.%s.tmorf"

@registry.register_problem
class TranslateEncsSubDersub(TranslateEncsTmorfsubTmorfsubBase):
	def corpus_lang(self, train, lang):
		if lang == "en":
			return "train.en-cs.en.tok" if train else "dev.en-cs.en.tok"
		return "train.en-cs.cs.der" if train else "dev.en-cs.cs.der"



#@registry.register_problem
#class TranslateEncsTmorfsubTmorfsub(TranslateEncsTmorfsubTmorfsubBase):
#	pass

## TODO: dodělat en.tmorf (zatim neni)
#@registry.register_problem
#class TranslateEncsTmorfsubDersub(TranslateEncsTmorfsubTmorfsubBase):
#	def corpus_lang(self, train, lang):
#		if lang == "en":
#			return "train.en-cs.%s.tmorf" if train else "dev.en-cs.%s.tmorf"
#		return "train.en-cs.cs.der" if train else "dev.en-cs.cs.der"


