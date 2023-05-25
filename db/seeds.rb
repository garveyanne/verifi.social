Comment.destroy_all
puts "cleared comment data"
Post.destroy_all
puts "cleared post data"
User.destroy_all
puts "cleared user data"


users = [
  { user_name: "Verifi", email: "user1@mail.com", password: "secret", age: 20, admin: true },
  { user_name: "sweet_smiles", email: "user2@mail.com", password: "secret", age: 22, admin: false },
  { user_name: "insta_bunny", email: "user3@mail.com", password: "secret", age: 24, admin:false },
  { user_name: "junnbugg", email: "user4@mail.com", password: "secret", age: 26, admin:false },
  { user_name: "minnie94", email: "user3@mail.com", password: "secret", age: 28, admin:false }
]
puts "creating users..."
users.each do |user|
  User.create(user)
end
puts "USERS created!"
user5 = User.last
user4 = User.find_by(age: 26)
user3 = User.find_by(age: 24)
user2 = User.find_by(age: 22)
user1 = User.first
puts "user1 - user5 assigned for use later.."


posts = [
  {title: "Why was my photo removed?", content: "Last week my photo was removed from instagram. I was wearing a bikini, but otherwise it is a normal picture.", user: user2, tag_list: ["instagram", "bikini"]},
  {title: "Does the background or tags of my post effect if it is removed?", content: "recently, my photo was removed, but I had a the exact same outfit and a similar pose in a different post that wasn't removed. I am wondering if the background or my tags was what got the post removed? any advice?", user: user2, tag_list: ["background", "tags", "advice"]},
  {title: "Will instagram give details on why something was deleted?", content: "My photo got a super low score overall and I honestly thought it was fine.. if I contact Instagram, will they give specifics?", user: user3, tag_list: ["instagram", "remove"]},
  {title: "I posed with my friends in a club and my pic was removed", content: "Yeah we were in a club but I have def posted more exposed photos before. Does the amount of people in the photo change anything?", user: user3, tag_list: ["instagram", "club", "group pic"]},
  {title: "My painting was taken down", content: "I am getting really frustrated that instagram keeps taking down my artwork. My work often scores high in suggestive and erotic... I don`t want to change my art just because instagram doesnt like the female body", user: user4, tag_list: ["instagram", "nude art", "artwork"]},
  {title: "What kind of text has caused your pictures to get removed?", content: "I recently made a piece regarding sexism in the work place and cat calling. my post was removed and I suspect it was from the text in the photo. my photo was marked as 'sexual' from Verifi... what words have you seen that have not been taken down?", user: user4, tag_list: ["instagram", "protest", "feminism", "art", "cat-calling"]}
]
puts "creating posts..."
posts.each do |post|
  Post.create(post)
end
puts "POSTS created!"
post1 = Post.find_by(title: "Why was my photo removed?")
post2 = Post.find_by(title: "Does the background or tags of my post effect if it is removed?")
post3 = Post.find_by(title: "Will instagram give details on why something was deleted?")
post4 = Post.find_by(title: "I posed with my friends in a club and my pic was removed")
post5 = Post.find_by(title: "My painting was taken down")
post6 = Post.find_by(title: "What kind of text has caused your pictures to get removed?")
puts "post1 - post6 assigned for use later.."



comments = [
  {content: "did you check your score? sometimes I get a really high score and insta flags me..", user: user3, post: post1 },
  {content: "It might have been the pose tbh.. bikini pics are usually okay, but the pose will get you removed", user: user4, post: post1 },
  {content: "same! I think it was the tags I used...", user: user4, post: post2 },
  {content: "What was the background?", user: user5, post: post2 },
  {content: "I dont think so", user: user2, post: post3 },
  {content: "When I contacted them in the past, they just say I broke guidelines ", user: user4, post: post3 },
  {content: "never change your art for insta! maybe you could add a tacky box over the 'bad parts' and call out insta for taking it down?", user: user5, post: post5 },
  {content: "that is horrible.. now that you say that, I dont see a lot of text on protest art on insta...", user: user5, post: post6 }
]
puts "creating comments..."
comments.each do |comment|
  Comment.create(comment)
end
puts "COMMENTS created!"
