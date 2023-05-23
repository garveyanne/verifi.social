Comment.destroy_all
puts "cleared comment data"
Post.destroy_all
puts "cleared post data"
User.destroy_all
puts "cleared user data"



users = [
  { user_name: "user1", email: "user1@mail.com", password: "secret", age: 20 },
  { user_name: "user2", email: "user2@mail.com", password: "secret", age: 22 },
  { user_name: "user3", email: "user3@mail.com", password: "secret", age: 24 }
]
puts "creating users..."
users.each do |user|
  User.create(user)
end
puts "USERS created!"
user3 = User.last
user2 = User.find_by(age: 22)
user1 = User.first
puts "user1, user2, and user3 assigned for use later.."


posts = [
  {title: "Why was my photo removed?", content: "Last week my photo was removed from instagram. I was wearing a bikini, but otherwise it is a normal picture.", user: user1, tag_list: ["instagram", "bikini"]},
  {title: "Does the background or tag of my post effect if it is removed?", content: "recently, my photo was removed, but I had a the exact same outfit and a similar pose in a different post that wasn't removed. I am wondering if the background or my tags was what got the post removed? any advice?", user: user3, tag_list: ["background", "tags"]}
]
puts "creating posts..."
posts.each do |post|
  Post.create(post)
end
puts "POSTS created!"
post1 = Post.first
post2 = Post.last
puts "post1 and post2 assigned for use later.."



comments = [
  {content: "did you check your score? sometimes I get a really high score and insta flags me..", user: user2, post: post1 },
  {content: "It might have been the pose tbh.. bikini pics are usually okay, but the pose will get you removed", user: user3, post: post1 },
  {content: "same! I think it was the tags I used...", user: user1, post: post2 },
  {content: "I think the setting is a huge factor in why a post gets taken down...", user: user2, post: post2 }
]
puts "creating comments..."
comments.each do |comment|
  Comment.create(comment)
end
puts "COMMENTS created!"
