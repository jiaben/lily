_TARGET_BUILD_CONTENTS_PATH=$TARGET_BUILD_DIR/$CONTENTS_FOLDER_PATH
echo _TARGET_BUILD_CONTENTS_PATH: $_TARGET_BUILD_CONTENTS_PATH
echo PWD: $PWD
echo Cleaning $_TARGET_BUILD_CONTENTS_PATH/

rm -rf $_TARGET_BUILD_CONTENTS_PATH/script/*
mkdir -p $_TARGET_BUILD_CONTENTS_PATH/script/
cp -RLp $PWD/../Resources/script/* $_TARGET_BUILD_CONTENTS_PATH/script/

rm -rf $_TARGET_BUILD_CONTENTS_PATH/res/*
mkdir -p $_TARGET_BUILD_CONTENTS_PATH/res/
cp -RLp $PWD/../Resources/res/* $_TARGET_BUILD_CONTENTS_PATH/res/

rm -rf $_TARGET_BUILD_CONTENTS_PATH/lang/*
mkdir -p $_TARGET_BUILD_CONTENTS_PATH/lang/
cp -RLp $PWD/../Resources/lang/* $_TARGET_BUILD_CONTENTS_PATH/lang/