# WeiChatSearchController
微信自定义搜索框
实现原理 1. 把搜索框作为UITableViewHeaderView， 这样的searchBar 可以跟随UITableView滑动，
        2. 用户的点击搜索框之后，监听shouldBegin 的方法，然后将searchController 添加到当前的控制器上
        3. 要想有动画效果，必须要自定义NavigationView， 让UITableView 和 NavigationView 同时向上做偏移，也就是orgin.Y 减少44
           动画过程中，要改变NavigationView 的背景颜色，和 SearchBar 的cancel效果
        4. 自定义UISearchBar， UINavigatonView， SearchController， SearchResultController
