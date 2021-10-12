# MyDiary

It's flutter web app, that enables any when to document his daily life and keep it 
online and secure with flutter and firebase as a backend.

## Main Features
- Getting Started page as welcome Page.![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/gettingStarted.PNG?raw=true)

- Create new account using FirebaseAuthentication service.![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/CreateAccount.PNG?raw=true)
- Sign in with FirebaseAuthentication if user is already has account.![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/signin.PNG?raw=true)
- Routing user to notFoundPage if he is not authorized (Not sign in). ![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/routing.PNG?raw=true)
- After sign in, user directed to the main page and see his diaries.if he doesnot have diary, he will see "click to add entry". 
![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/mainpage.PNG?raw=true)
- User can navigate between days to see his diaries in the specific day.
- Add new diary with title, body and optional image. ![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/newdiary.PNG?raw=true)
- If user does not add an image, default image will be added.
- Delete diary. ![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/delete.PNG?raw=true)
- Edit diary. User can change title, body and the image.![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/edit.PNG?raw=true)
- Update Profile. User can change his name and profile pic. ![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/updateprofile.PNG?raw=true)
- Filtering diaries in specific day with latest or earliest time they were added. ![alt text](https://github.com/albraa-abdalla/MyDiary/blob/main/my_diary/images/latest.PNG?raw=true)
- Logout. After user ended his journaling.

##Future work
- Localization. Adding arabic language.
- Improve user experience by using strong state management approach like BLOC.
- Responsiveness. Make it responsive with all screen sizes.
