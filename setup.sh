#!/bin/sh

echo "converting audio to ogg"
cd assets/sounds/de/
for i in *.oga; do ffmpeg -i "$i" "${i%.*}.mp3" ; done
rm *.oga
cd ../../../

echo "creating json from srt files..."
cd assets/text/de/srt
./convertAllToJson.sh
cd ../../../../

echo "fixing newlines on txt files..."
/bin/bash fixNewlineTextFiles.sh assets/text/de/

echo "creating locale mappings..."
python3 genLocale.py python_templates/LocaleDE_Template.hx  assets/text/de/ assets/sounds/de/ > source/locale/LocaleDE.hx

echo "creating Factories.."

python3 genFactory.py python_templates/StateFactoryElseIf_Template.hx source/dnaobject/DnaStateFactory.hx assets/data/DnaStateArchetypes/ > DnaStateFactory.hx
mv DnaStateFactory.hx source/dnaobject/DnaStateFactory.hx 

python3 genFactory.py python_templates/ComponentFactoryElseIf_Template.hx source/dnaobject/DnaComponentFactory.hx assets/data/DnaComponentArchetypes/ > DnaComponentFactory.hx
mv DnaComponentFactory.hx source/dnaobject/DnaComponentFactory.hx 

python3 genFactory.py python_templates/ObjectFactoryElseIf_Template.hx source/dnaobject/DnaObjectFactory.hx assets/data/DnaObjectArchetypes/ > DnaObjectFactory.hx
mv DnaObjectFactory.hx source/dnaobject/DnaObjectFactory.hx


python3 genTests.py python_templates/TestTemplate.hx assets/data/DnaStateArchetypes/ test/tests/states/

echo "setup done."
#lime test neko
