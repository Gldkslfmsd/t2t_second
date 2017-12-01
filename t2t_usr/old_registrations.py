import os

from tensor2tensor.models import transformer
from tensor2tensor.utils import registry
from tensor2tensor.data_generators import problem

import tensor2tensor.data_generators.translate as translate

from tensor2tensor.data_generators import text_encoder, generator_utils

import tensorflow as tf

FLAGS = tf.flags.FLAGS

# End-of-sentence marker.
EOS = text_encoder.EOS_ID
UNK = "__UNK__"

import logging



from . import my_registrations as m

# bpe50k má špatný počet slov pro aa a zz

@registry.register_problem
class TranslateDecsBpe50kzz(m.TranslateDecsBase):
	def corpus(self, train):
		return "zz.train.%s.bpe50k" if train else "zz.dev.%s.bpe50k"

##@registry.register_problem
##class TranslateDecsBpe50k(m.TranslateDecsBase):
##	def corpus(self, train):
##		return "train.%s.bpe50k" if train else "dev.%s.bpe50k"
#
@registry.register_problem
class TranslateDecsBpe50kaa(m.TranslateDecsBase):
	def corpus(self, train):
		return "aa.train.%s.bpe50k" if train else "aa.dev.%s.bpe50k"
#
#@registry.register_problem
#class TranslateDecsPmorfaa(m.TranslateDecsBase):
#	def corpus(self, train):
#		return "aa.train.%s.pmorf" if train else "aa.dev.%s.pmorf"
#
#@registry.register_problem
#class TranslateDecsPmorfzz(m.TranslateDecsBase):
#	def corpus(self, train):
#		return "zz.train.%s.pmorf" if train else "zz.dev.%s.pmorf"
#
#
#@registry.register_problem
#class TranslateDecsAazzpmorf(m.TranslateDecsAazzBase):
#	SPLIT = "pmorf"	
#
@registry.register_problem
class TranslateDecsAazzbpe50k(m.TranslateDecsAazzBase):
	SPLIT = "bpe50k"	
#
#
