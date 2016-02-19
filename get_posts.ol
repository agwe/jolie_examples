type guid = string("[A-F\\d]{8,8}-[A-F\\d]{4,4}-[A-F\\d]{4,4}-[A-F\\d]{4,4}-[A-F\\d]{12,12}")

type user: void {
  .uid: guid
  .name: string
  .age: int(age>18)
}

type post_type: void {
  .pid : guid;
  .owner : guid;
  .content : string;
}

type posts: void {
  .post*:post_type
}

interface UserPostsInterface {
  RequestResponse: find_user_by_name(string)(user)
  RequestResponse: get_all_posts_by_user(guid)(posts)
}

inputPort SelfIn {
  Location: "local"
  Interfaces: UserPostsInterface
}

inputPort SelfHttp {
  Location: "socket://localhost:8000"
  Protocol: http
  Interfaces: UserPostsInterface
}

outputPort SelfOut{
  Location: "local"
  Interfaces: UserPostsInterface
}

execution{ concurrent }
init { getLocalLocation@Runtime()( SelfOut.location ) }

main
{
  all_posts_by_user (name) {
    find_user_by_name@SelfOut(name)(user);
    get_all_users_posts@SelfOut(user.uid)(posts) 
  }
  
  \\find_user_by_name definition
  \\...
}
