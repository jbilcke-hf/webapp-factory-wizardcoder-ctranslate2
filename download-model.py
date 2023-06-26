# a small hack for Pythonia, this allows us to download WizardCoder to it's download directory
# that way it will become readily available to our Node program

from hf_hub_ctranslate2 import TranslatorCT2fromHfHub, GeneratorCT2fromHfHub
from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("WizardLM/WizardCoder-15B-V1.0")

model = GeneratorCT2fromHfHub(
  model_name_or_path="michaelfeil/ct2fast-WizardCoder-15B-V1.0",
  device="cpu",
  compute_type="int8",
)