class AppString {
  /// General
  static const String maersk = 'Maersk';
  static const String createNewInspectionBtnText = 'Create New Inspection';
  static const String appVersion = '1.0.0';
  static const String appVersionCode = '1';

  static const String maerskLogoSvg =
      '''<svg width="31" height="32" viewBox="0 0 31 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M3.64574 0H26.6726C27.641 0 28.5698 0.384721 29.2546 1.06953C29.9394 1.75434 30.3242 2.68313 30.3242 3.6516V28.3484C30.3242 29.3169 29.9394 30.2457 29.2546 30.9305C28.5698 31.6153 27.641 32 26.6726 32H3.64574C2.67883 32 1.75153 31.6159 1.06782 30.9322C0.38412 30.2485 1.89701e-05 29.3212 1.89701e-05 28.3543V3.65748C-0.00152862 3.17773 0.0916286 2.70239 0.27415 2.25871C0.456672 1.81503 0.724967 1.41174 1.06366 1.07196C1.40235 0.732177 1.80477 0.462585 2.24786 0.278635C2.69095 0.0946858 3.16598 -2.49607e-06 3.64574 0Z" fill="#42B0D5"/>
<path d="M19.9939 15.171L25.9799 7.66202L25.9623 7.6385L17.3125 11.8017L15.178 2.44629H15.1427L13.0082 11.8017L4.35843 7.6385L4.34079 7.66202L10.3268 15.171L1.67706 19.3342L1.68882 19.3636H11.2853L9.15079 28.7249L9.17431 28.7366L15.1603 21.2276L21.1464 28.7366L21.1758 28.719L19.0354 19.3636H28.6377L28.6436 19.3342L19.9939 15.171Z" fill="white"/>
</svg>''';

  static const String downloadDirPathAndroid = '/storage/emulated/0/Download';
  static const String pictureDirPathAndroid = '/storage/emulated/0/Pictures';
  static const String downloadDirPathIOS = '';

  static const String requiredField = '*Required';

  /// PDF
  static const String page = 'Page';
  static const String preliminaryReportSuccessMsg = 'Preliminary report downloaded successfully';
  static const String noRiskImagesMsg = 'No images in risks library';
  static const String preliminaryReportTxt = 'Preliminary_Report';
  static const String preliminaryReportFailureMsg = 'Failed to generate preliminary report';
  static const String generatingPdfTxt = 'Generating PDF...';
  static const String generatePreliminaryTxt = 'Generate a Preliminary Report';

  /// Camera
  static const String cameraLoading = 'Camera Loading...';
  static const String pictureNotSaved = "Couldn't save the image, Please try again";

  /// Zip
  static const String zipFileGenerationMssg = 'Generating Zip File...';
  static const String zipFileGenerationSuccessMssg = 'Zip file generated successfully!';
  static const String zipFileGenerationFailureMssg = 'Failed to generate Zip file!';
  static const String zipFileNoImgsMssg = 'No images to export and generate Zip file!';
}
