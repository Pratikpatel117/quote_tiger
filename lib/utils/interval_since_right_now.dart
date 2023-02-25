String intervalSinceCurrentMoment(DateTime from) {
  var diff = DateTime.now().difference(from);
  if (diff.inDays >= 365) {
    var years = diff.inDays ~/ 365;
    if (years == 1) {
      return 'an year ago';
    }

    return 'about $years years ago';
  }
  if (diff.inDays >= 30) {
    var months = diff.inDays ~/ 30;
    if (months == 1) {
      return 'a month ago';
    }
    return 'about $months months ago';
  }
  if (diff.inDays > 0) {
    if (diff.inDays == 1) {
      return 'a day ago';
    }
    return '${diff.inDays} days ago';
  }
  if (diff.inHours > 0) {
    if (diff.inHours == 1) {
      return 'an hour ago';
    }
    return '${diff.inHours} hours ago';
  }

  if (diff.inMinutes > 0) {
    if (diff.inMinutes == 1) {
      return 'a minute ago';
    }
    return '${diff.inMinutes} mins ago';
  }

  //now for the future stuff
  if (diff.inDays <= -365) {
    var years = diff.inDays ~/ 365;
    if (years == 1) {
      return 'an year into the future';
    }

    return 'about ${years.abs()} years into the future';
  }
  if (diff.inDays <= -30) {
    var months = diff.inDays ~/ 30;
    if (months == 1) {
      return 'a month into the future';
    }
    return 'about ${months.abs()} months into the future';
  }
  if (diff.inDays < 0) {
    if (diff.inDays == 1) {
      return 'a day into the future';
    }
    return '${diff.inDays.abs()} days int othe future';
  }
  if (diff.inHours < 0) {
    if (diff.inHours == 1) {
      return 'an hour ago';
    }
    return '${diff.inHours.abs()} hours into the future';
  }

  if (diff.inMinutes < 0) {
    if (diff.inMinutes == 1) {
      return 'a minute into the future';
    }
    return '${diff.inMinutes.abs()} mins into the future';
  }

  if (diff.inSeconds < 30) {
    return 'just now';
  }
  return '${diff.inSeconds} seconds ago';
}
