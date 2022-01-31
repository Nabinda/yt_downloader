 class TimeAgo {
   String uploadTimeAgo(DateTime uploadDateTime) {
    Duration difference = DateTime.now().difference(uploadDateTime);
    if ((difference.inDays / 365).floor() >= 1) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
   String formatDuration(Duration d) {
     if (d.inHours <= 0) {
       String min;
       String sec;
       if (d.inMinutes < 10) {
         min = "0" + d.inMinutes.toString();
       } else {
         min = d.inMinutes.toString();
       }
       if (d.inSeconds % 60 < 10) {
         sec = "0" + (d.inSeconds % 60).toString();
       } else {
         sec = (d.inSeconds % 60).toString();
       }
       return min + ":" + sec;
     }
     return d.toString().split('.').first.padLeft(8, "0");
   }
}