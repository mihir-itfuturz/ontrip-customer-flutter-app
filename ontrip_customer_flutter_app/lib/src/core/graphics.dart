class Graphics with _Images, _Icons {
  Graphics._();
  static final instance = Graphics._();
  factory Graphics() => instance;
}

mixin _Icons {
  static final _path = 'assets/icons';
  final iconAdd = '$_path/add.svg';
  final iconBack = '$_path/back.svg';
  final iconBag = '$_path/bag.svg';
  final iconCall = '$_path/call.svg';
  final iconCallWhite = '$_path/call_white.svg';
  final iconClose = '$_path/close.svg';
  final iconContactUs = "$_path/contact_us.svg";
  final iconDelete = '$_path/delete.svg';
  final iconDeleteWhite = '$_path/delete_white.svg';
  final iconEditPen = "$_path/edit_pen.svg";
  final iconDownload = '$_path/download.svg';
  final iconEmail = '$_path/email.svg';
  final iconGallery = "$_path/gallery.svg";
  final iconMoreMenu = "$_path/more_menu.svg";
  final iconMoreHorizontal = '$_path/more_horizontal.svg';
  final iconMoreVertical = '$_path/more_vertical.svg';
  final iconFaceBook = '$_path/facebook.svg';
  final iconFlashLightOff = '$_path/flash_light_off.svg';
  final iconFlashLight = '$_path/flash_light.svg';
  final iconFollowUp = '$_path/follow_up.svg';
  final iconGoogle = '$_path/google.svg';
  final iconGrowth = '$_path/growth.svg';
  final iconGST = '$_path/gst.svg';
  final iconInstagram = '$_path/instagram.svg';
  final iconInstagramBG = '$_path/instagram_bg.svg';
  final iconLocation = '$_path/location.svg';
  final iconLogoutRed = '$_path/logout_red.svg';
  final iconLogoutWhite = '$_path/logout_white.svg';
  final iconMicrophone = '$_path/microphone.svg';
  final iconNext = '$_path/next.svg';
  final iconNote = '$_path/note.svg';
  final iconPAN = '$_path/pan.svg';
  final iconProduct = '$_path/products.svg';
  final iconQrScanner = '$_path/qr_scanner.svg';
  final iconProfile = '$_path/profile.svg';
  final iconService = '$_path/services.svg';
  final iconShare = '$_path/share.svg';
  final iconCommunity = '$_path/site.svg';
  final iconHistory = '$_path/task_note.svg';
  final iconScan = '$_path/scan.svg';
  final iconWebsite = '$_path/website.svg';
  final iconWhatsAppGreen = '$_path/what_app_green.svg';
  final iconWhatsApp = '$_path/whats_app.svg';
  final iconTransfer = '$_path/transfer.svg';
  final iconTaskNote = '$_path/task_note.svg';
  final iconThemeWhite = '$_path/theme_white.svg';
  final iconTheme = '$_path/theme.svg';
  final iconRefresh = '$_path/refresh.svg';
  final iconSearch = '$_path/search.svg';
  final iconSkype = '$_path/skype.svg';
  final iconTick = '$_path/tick.svg';
  final iconHome = '$_path/home.svg';
  final iconDirection = '$_path/direction.svg';
  final iconCard = '$_path/card.svg';
  final iconSetting = '$_path/setting.svg';
  final iconHomeFill = '$_path/home_fill.svg';
  final iconDirectionFill = '$_path/direction_fill.svg';
  final iconCardFill = '$_path/card_fill.svg';
  final iconSettingFill = '$_path/setting_fill.svg';
}

mixin _Images {
  static final _path = 'assets/images';
  final logo = '$_path/logo.png';
  final noImage = '$_path/no_image.png';
  final userProfile = '$_path/user_profile.jpg';
  final profileBackground = '$_path/profile_background.png';
  final banner = '$_path/banner.jpeg';
  final layout = '$_path/layout.png';
  final overlay = '$_path/overlay.png';
}
