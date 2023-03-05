part of '../constants.dart';

const kProductListLayout = [
  {'layout': 'list', 'image': 'assets/icons/tabs/icon-list.png'},
  {'layout': 'columns', 'image': 'assets/icons/tabs/icon-columns.png'},
  {'layout': 'card', 'image': 'assets/icons/tabs/icon-card.png'},
  {'layout': 'horizontal', 'image': 'assets/icons/tabs/icon-horizon.png'},
  {'layout': 'listTile', 'image': 'assets/icons/tabs/icon-lists.png'},
];

const kBlogListLayout = [
  {'layout': 'list', 'image': 'assets/icons/tabs/icon-list.png'},
  {'layout': 'columns', 'image': 'assets/icons/tabs/icon-columns.png'},
  {'layout': 'listTile', 'image': 'assets/icons/tabs/icon-lists.png'},
];

const kDefaultImage =
    'https://trello-attachments.s3.amazonaws.com/5d64f19a7cd71013a9a418cf/640x480/1dfc14f78ab0dbb3de0e62ae7ebded0c/placeholder.jpg';

const kLogoImage = 'assets/images/logo.png';

const kProfileBackground =
    'https://images.unsplash.com/photo-1494253109108-2e30c049369b?ixlib=rb-1.2.1&auto=format&fit=crop&w=3150&q=80';

const String kLogo = 'assets/images/logo.png';

const String kEmptySearch = 'assets/images/empty_search.png';

const String kOrderCompleted = 'assets/images/fogg-order-completed.png';

/// This is for grid category layout & side menu with sub category layout.
/// id_category : image_category
/// image_category can be network image (begins with "https://")
/// or asset image (begins with "assets/")
const kGridIconsCategories = {
  '24': 'https://mstore.io/wp-content/uploads/2015/08/image3xxl-53-150x150.jpg',
  '30': 'https://mstore.io/wp-content/uploads/2015/08/image1xxl-45-150x150.jpg',
  '19':
      'https://mstore.io/wp-content/uploads/2015/08/image1xxl-103-150x150.jpg',
  '21': 'https://mstore.io/wp-content/uploads/2015/08/image1xxl-85-150x150.jpg',
  '25': 'https://mstore.io/wp-content/uploads/2015/07/image1xxl-11-150x150.jpg',
  '27': 'https://mstore.io/wp-content/uploads/2015/07/image2xxl-51-150x150.jpg',
  '29': 'https://mstore.io/wp-content/uploads/2015/07/image2xxl-5-150x150.jpg'
};

const Map kCategoryStaticImages = {
  // 30: 'https://images.unsplash.com/photo-1448131063153-f1e240f98a72?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  // 41: 'https://images.unsplash.com/photo-1496318447583-f524534e9ce1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  // 45: 'https://images.unsplash.com/photo-1558920558-fb0345e52561?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  // 46: 'https://images.unsplash.com/photo-1575301579296-39d50573daf5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
  // 40: 'https://images.unsplash.com/photo-1467453678174-768ec283a940?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  // 37: 'https://images.unsplash.com/photo-1505678261036-a3fcc5e884ee?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  // 31: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  // 36: 'https://images.unsplash.com/photo-1555196301-9acc011dfde4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  // 32: 'https://images.unsplash.com/photo-1517614138969-67d1892d0edf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  // 33: 'https://images.unsplash.com/photo-1532301791573-4e6ce86a085f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60',
  // 34: 'https://images.unsplash.com/photo-1494919997560-caff2f1cff75?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1033&q=80',
};

/// This image proxy is use to optimize the image loading the or resolve the CORS
const kImageProxy = '';

const kCacheImageWidth = 700;
