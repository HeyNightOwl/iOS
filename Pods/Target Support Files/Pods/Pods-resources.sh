#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

realpath() {
  DIRECTORY=$(cd "${1%/*}" && pwd)
  FILENAME="${1##*/}"
  echo "$DIRECTORY/$FILENAME"
}

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm\""
      xcrun mapc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE=$(realpath "${PODS_ROOT}/$1")
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "FormatterKit/Localizations/ca.lproj"
  install_resource "FormatterKit/Localizations/cs.lproj"
  install_resource "FormatterKit/Localizations/da.lproj"
  install_resource "FormatterKit/Localizations/de.lproj"
  install_resource "FormatterKit/Localizations/el.lproj"
  install_resource "FormatterKit/Localizations/en.lproj"
  install_resource "FormatterKit/Localizations/es.lproj"
  install_resource "FormatterKit/Localizations/fr.lproj"
  install_resource "FormatterKit/Localizations/id.lproj"
  install_resource "FormatterKit/Localizations/it.lproj"
  install_resource "FormatterKit/Localizations/ja.lproj"
  install_resource "FormatterKit/Localizations/ko.lproj"
  install_resource "FormatterKit/Localizations/nb.lproj"
  install_resource "FormatterKit/Localizations/nl.lproj"
  install_resource "FormatterKit/Localizations/nn.lproj"
  install_resource "FormatterKit/Localizations/pl.lproj"
  install_resource "FormatterKit/Localizations/pt.lproj"
  install_resource "FormatterKit/Localizations/pt_BR.lproj"
  install_resource "FormatterKit/Localizations/ru.lproj"
  install_resource "FormatterKit/Localizations/sv.lproj"
  install_resource "FormatterKit/Localizations/tr.lproj"
  install_resource "FormatterKit/Localizations/uk.lproj"
  install_resource "FormatterKit/Localizations/vi.lproj"
  install_resource "FormatterKit/Localizations/zh-Hans.lproj"
  install_resource "FormatterKit/Localizations/zh-Hant.lproj"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_received.aiff"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_sent.aiff"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Controllers/JSQMessagesViewController.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellIncoming.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellOutgoing.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesLoadEarlierHeaderView.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesToolbarContentView.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesTypingIndicatorFooterView.xib"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPArrowLeft.imageset/MPArrowLeft.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPArrowLeft.imageset/MPArrowLeft@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPArrowRight.imageset/MPArrowRight.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPArrowRight.imageset/MPArrowRight@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPCheckmark.imageset/MPCheckmark.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPCheckmark.imageset/MPCheckmark@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPCloseBtn.imageset/MPCloseBtn.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPCloseBtn.imageset/MPCloseBtn@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPDismissKeyboard.imageset/MPDismissKeyboard.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPDismissKeyboard.imageset/MPDismissKeyboard@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPLogo.imageset/MPLogo.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPLogo.imageset/MPLogo@2x.png"
  install_resource "Mixpanel/Mixpanel/MPCloseBtn.png"
  install_resource "Mixpanel/Mixpanel/MPCloseBtn@2x.png"
  install_resource "Mixpanel/Mixpanel/MPNotification.storyboard"
  install_resource "Mixpanel/Mixpanel/MPSurvey.storyboard"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/amex.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/amex@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc-amex.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc-amex@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/diners.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/diners@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/discover.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/discover@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/jcb.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/jcb@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/mastercard.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/mastercard@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/placeholder.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/placeholder@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/visa.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/visa@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/gradient@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/textfield.png"
  install_resource "PaymentKit/PaymentKit/Resources/textfield@2x.png"
  install_resource "libPhoneNumber-iOS/libPhoneNumber/NBPhoneNumberMetadata.plist"
  install_resource "${BUILT_PRODUCTS_DIR}/MaveSDK.bundle"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "FormatterKit/Localizations/ca.lproj"
  install_resource "FormatterKit/Localizations/cs.lproj"
  install_resource "FormatterKit/Localizations/da.lproj"
  install_resource "FormatterKit/Localizations/de.lproj"
  install_resource "FormatterKit/Localizations/el.lproj"
  install_resource "FormatterKit/Localizations/en.lproj"
  install_resource "FormatterKit/Localizations/es.lproj"
  install_resource "FormatterKit/Localizations/fr.lproj"
  install_resource "FormatterKit/Localizations/id.lproj"
  install_resource "FormatterKit/Localizations/it.lproj"
  install_resource "FormatterKit/Localizations/ja.lproj"
  install_resource "FormatterKit/Localizations/ko.lproj"
  install_resource "FormatterKit/Localizations/nb.lproj"
  install_resource "FormatterKit/Localizations/nl.lproj"
  install_resource "FormatterKit/Localizations/nn.lproj"
  install_resource "FormatterKit/Localizations/pl.lproj"
  install_resource "FormatterKit/Localizations/pt.lproj"
  install_resource "FormatterKit/Localizations/pt_BR.lproj"
  install_resource "FormatterKit/Localizations/ru.lproj"
  install_resource "FormatterKit/Localizations/sv.lproj"
  install_resource "FormatterKit/Localizations/tr.lproj"
  install_resource "FormatterKit/Localizations/uk.lproj"
  install_resource "FormatterKit/Localizations/vi.lproj"
  install_resource "FormatterKit/Localizations/zh-Hans.lproj"
  install_resource "FormatterKit/Localizations/zh-Hant.lproj"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_min_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_stroked_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/bubble_tailless@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/camera@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Images/typing@2x.png"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_received.aiff"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Assets/Sounds/message_sent.aiff"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Controllers/JSQMessagesViewController.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellIncoming.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesCollectionViewCellOutgoing.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesLoadEarlierHeaderView.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesToolbarContentView.xib"
  install_resource "JSQMessagesViewController/JSQMessagesViewController/Views/JSQMessagesTypingIndicatorFooterView.xib"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPArrowLeft.imageset/MPArrowLeft.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPArrowLeft.imageset/MPArrowLeft@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPArrowRight.imageset/MPArrowRight.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPArrowRight.imageset/MPArrowRight@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPCheckmark.imageset/MPCheckmark.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPCheckmark.imageset/MPCheckmark@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPCloseBtn.imageset/MPCloseBtn.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPCloseBtn.imageset/MPCloseBtn@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPDismissKeyboard.imageset/MPDismissKeyboard.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPDismissKeyboard.imageset/MPDismissKeyboard@2x.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPLogo.imageset/MPLogo.png"
  install_resource "Mixpanel/Mixpanel/Media.xcassets/MPLogo.imageset/MPLogo@2x.png"
  install_resource "Mixpanel/Mixpanel/MPCloseBtn.png"
  install_resource "Mixpanel/Mixpanel/MPCloseBtn@2x.png"
  install_resource "Mixpanel/Mixpanel/MPNotification.storyboard"
  install_resource "Mixpanel/Mixpanel/MPSurvey.storyboard"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/amex.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/amex@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc-amex.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc-amex@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/cvc@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/diners.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/diners@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/discover.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/discover@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/jcb.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/jcb@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/mastercard.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/mastercard@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/placeholder.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/placeholder@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/visa.png"
  install_resource "PaymentKit/PaymentKit/Resources/Cards/visa@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/gradient@2x.png"
  install_resource "PaymentKit/PaymentKit/Resources/textfield.png"
  install_resource "PaymentKit/PaymentKit/Resources/textfield@2x.png"
  install_resource "libPhoneNumber-iOS/libPhoneNumber/NBPhoneNumberMetadata.plist"
  install_resource "${BUILT_PRODUCTS_DIR}/MaveSDK.bundle"
fi

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac

  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "`realpath $PODS_ROOT`*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
