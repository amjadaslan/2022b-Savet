import '../models/category.dart';

class AppData {
  static List<Category> categories = [
    Category(
        imageUrl: 'assets/images/recently_added.jpg',
        CategoryName: 'Recently Added',
        Description: 'Bla bla bla bla bla',
        imagesList: []),
    Category(
        imageUrl: 'assets/images/movies.jpg',
        CategoryName: 'Movies',
        Description: 'Bla bla bla bla bla',
        imagesList: [
          'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg',
          'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
          'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg',
          'https://media.istockphoto.com/photos/woman-kayaking-in-fjord-in-norway-picture-id1059380230?b=1&k=6&m=1059380230&s=170667a&w=0&h=kA_A_XrhZJjw2bo5jIJ7089-VktFK0h0I4OWDqaac0c=',
          'https://cdn.pixabay.com/photo/2019/11/05/00/53/cellular-4602489_960_720.jpg',
          'https://cdn.pixabay.com/photo/2017/02/12/10/29/christmas-2059698_960_720.jpg',
        ]),
    Category(
        imageUrl: 'assets/images/books.jpg',
        CategoryName: 'Books',
        Description: 'Bla bla bla bla bla',
        imagesList: [
          'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg'
        ]),
    Category(
        imageUrl: 'assets/images/food.jpg',
        CategoryName: 'Food',
        Description: 'Bla bla bla bla bla',
        imagesList: [
          'https://cdn.pixabay.com/photo/2019/03/15/09/49/girl-4056684_960_720.jpg',
          'https://cdn.pixabay.com/photo/2020/12/15/16/25/clock-5834193__340.jpg',
          'https://cdn.pixabay.com/photo/2020/09/18/19/31/laptop-5582775_960_720.jpg'
        ]),
  ];
}
