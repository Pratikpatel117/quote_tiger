import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QIcon extends StatelessWidget {
  final QIconData qIconData;
  final Color color;
  final double size;
  const QIcon(this.qIconData,
      {Key? key, this.color = Colors.black, this.size = 25})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child:
          SvgPicture.asset(qIconData.svgPath, color: color, fit: BoxFit.fill),
    );
  }
}

class QIcons {
  static QIconData get q => QIconData('assets/svg/q.svg');
  static QIconData get addMedia => QIconData('assets/svg/add_media.svg');
  static QIconData get arrow => QIconData('assets/svg/arrow.svg');
  static QIconData get bookmark => QIconData('assets/svg/bookmark.svg');
  static QIconData get check => QIconData('assets/svg/check.svg');
  static QIconData get close => QIconData('assets/svg/close.svg');
  static QIconData get down => QIconData('assets/svg/down.svg');
  static QIconData get editProfile => QIconData('assets/svg/edit_profile.svg');
  static QIconData get edit => QIconData('assets/svg/edit.svg');
  static QIconData get hamburgerLeft =>
      QIconData('assets/svg/hamburger_left.svg');
  static QIconData get hamburger => QIconData('assets/svg/hamburger.svg');
  static QIconData get help => QIconData('assets/svg/help.svg');
  static QIconData get home => QIconData('assets/svg/home.svg');
  static QIconData get invite => QIconData('assets/svg/invite.svg');
  static QIconData get logout => QIconData('assets/svg/logout.svg');
  static QIconData get menu => QIconData('assets/svg/menu.svg');
  static QIconData get message => QIconData('assets/svg/message.svg');
  static QIconData get newMessage => QIconData('assets/svg/new_message.svg');
  static QIconData get notification => QIconData('assets/svg/notification.svg');
  static QIconData get photo => QIconData('assets/svg/photo.svg');
  static QIconData get play => QIconData('assets/svg/play.svg');
  static QIconData get plus => QIconData('assets/svg/plus.svg');
  static QIconData get quote => QIconData('assets/svg/quote.svg');
  static QIconData get request => QIconData('assets/svg/request.svg');
  static QIconData get search => QIconData('assets/svg/search.svg');
  static QIconData get send => QIconData('assets/svg/send.svg');
  static QIconData get settings => QIconData('assets/svg/settings.svg');
  static QIconData get share2 => QIconData('assets/svg/share_2.svg');
  static QIconData get share3 => QIconData('assets/svg/share_3.svg');
  static QIconData get share => QIconData('assets/svg/share.svg');
  static QIconData get star => QIconData('assets/svg/star.svg');
}

class QIconData {
  final String svgPath;

  QIconData(this.svgPath);
}
