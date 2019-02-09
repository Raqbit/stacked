String getRankName(int rank) {
  switch (rank) {
    case 1:
      return 'ace';
      break;
    case 11:
      return 'jack';
      break;
    case 12:
      return 'queen';
      break;
    case 13:
      return 'king';
      break;
    default:
      return rank.toString();
  }
}

bool isGraphic(int rank) {
  switch(rank) {
    case 11:
    case 12:
    case 13:
      return true;
      break;
  }

  return false;
}