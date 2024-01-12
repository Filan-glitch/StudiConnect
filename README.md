# StudiConnect

StudiConnect is a Flutter project aimed at connecting students and facilitating collaboration among them. This README provides an overview of the project, its features, and how to get started.

## Features

- User authentication: Students can create an account and log in to access the app's features.
- Profile management: Users can update their profile information, including their name, profile picture, and contact details.
- Study groups: Students can create or join study groups based on their courses or subjects of interest.
- Chat: Users can chat with other students in their study groups to discuss topics and to arrange meetings.

## Dependencies

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [VS Code](https://code.visualstudio.com/download) or [Android Studio](https://developer.android.com/studio)

## Getting Started

To run the StudiConnect app locally, follow these steps:

1. Clone the repository: `git clone https://github.com/Filan-glitch/StudiConnect.git`
2. Navigate to the project directory: `cd StudiConnect`
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

Make sure you have Flutter installed on your machine before running the app.

## Demo Video

It exists a demo video of the usage of our application. You can find it [here](https://studiconnect.janbellenberg.de/demo.mp4)

## Important Notes

- The app uses Firebase for authentication. To enable OAuth2 authentication with Google, you need to follow these steps (Step 1 and 2 are only required if you want to use the release version of the app):
  1. Create a new keystore file: `keytool -genkeypair -v -keystore keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key -storepass <store password> -keypass <key password>` and place it in the `android/app` directory.
  2. Create a new key.properties file in the `android` directory and add the following lines to it:

      ``` text
      storePassword=<password from previous step>
      keyPassword=<password from previous step>
      keyAlias=key
      storeFile=<location of the key store file, e.g. C:/Users/.../keystore.jks>
      ```

  3. Open the terminal and navigate to the `android` directory:

      ``` batch
      cd android
      ```
  
  4. Call the gradle command `signingReport`:

      ``` batch
      ./gradlew signingReport
      ```

      The result then should look like this:

      ``` batch
      > Task :app:signingReport
      Variant: debug
      Config: debug
      Store: C:\Users\{user}\.android\debug.keystore
      Alias: AndroidDebugKey
      MD5: 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
      SHA1: 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
      SHA-256: 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
      Valid until: Montag, 12. Mai 2053
      ----------
      Variant: release
      Config: release
      Store: C:\Users\{user}\StudiConnect\android\app\release-keystore.jks
      Alias: release
      MD5: 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
      SHA1: 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
      SHA-256: 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
      Valid until: Montag, 4. Januar 2049
      ```

  5. The SHA-1 key is the one you need to enable Google authentication. If you want to use the release version of the app, you also need the SHA-1 key of the release keystore to the Firebase project settings.
  6. Finally, contact us to add your SHA-1 keys to the Firebase project settings.
- For simplicity, we have a ready to use apk file in the releases section of this repository. You can download it and install it on your Android device to test the app. The apk file is signed with our release keystore, so you don't need to follow the steps above to enable Google authentication.

## Important Links

The StudiConnect website is available at [studiconnect.janbellenberg.de](https://studiconnect.janbellenberg.de).  
The documentation is available at [studiconnect.janbellenberg.de/docs](https://studiconnect.janbellenberg.de/docs).  
The privacy policy is available at [studiconnect.janbellenberg.de/privacy](https://studiconnect.janbellenberg.de/privacy).  
The terms and conditions are available at [studiconnect.janbellenberg.de/terms](https://studiconnect.janbellenberg.de/terms).  
The imprint is available at [studiconnect.janbellenberg.de/imprint](https://studiconnect.janbellenberg.de/imprint).  

## License

StudiConnect is released under the [MIT License](https://opensource.org/licenses/MIT). See the [LICENSE](LICENSE) file for more details.

## Contact

If you have any questions or suggestions regarding StudiConnect, please feel free to reach out to us at [Finn Dilan](mailto:finn.dilan@stud.hs-ruhrwest.de) or [Jan Bellenberg](mailto:jan.bellenberg@stud.hs-ruhrwest.de).

Happy studying and connecting!
