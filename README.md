# t2t_second

Set of scripts used for experiments described in paper 
*Morphological and Language-Agnostic Word Segmentation for NMT* https://arxiv.org/abs/1806.05482 .

The scripts were not inteded for public and reuse, they're not clear or commented. Feel free to ask for explanation or details.

Requirements:

- this fork of Tensor2Tensor: https://github.com/Gldkslfmsd/tensor2tensor
  - it is T2T 1.2.9 + one simple modification of logging not affecting the core and performance on translation
- 11GB RAM GPU
- etc.


Remarkable:

t2t_usr/
- T2T user dir with definitions and implementations of problems

t2t_user/my_registrations.py
- class TranslateDecsSubwords100kFbb100m: STE baseline
- class TranslateDecsBpe: BPE run

gen-train-dec.sh
- entry point to launch generator and trainer

