# The Haunted Signup Mansion

MAD 4360 In-Class Activity 11, Graduate Track  
Selected extension: **Task C — The Guarded Crypt**

## Group

- Student: **Muhammad Mustufa**
- Repository: https://github.com/mustafadev123/in_class_11

## App overview

The app is a three-screen haunted signup experience. The Welcome screen opens
the Signup screen, which keeps the instructor's Activity 10 name, email, and
password checks and adds a password toggle, birth-date picker, and loading
state. A valid signup replaces the form with a personalized Success screen and
plays confetti.

## Graduate extension

Task C protects the app from three hostile cases. A blank name sent directly to
the Success screen returns the visitor to the Welcome screen. A separate guard
stops a second submission even before the disabled button is redrawn. If the
visitor leaves during the two-second wait, the app checks that the form is still
open before trying to move forward.

## Test evidence

Run the repeatable tests with:

```text
flutter test
```

| Case | Expected | Observed |
|---|---|---|
| Empty form | Name, email, password, and birth-date messages appear | Passed in `shows all required errors for empty input` |
| Bad email and short password | Both matching messages appear | Passed in `rejects an invalid email and short password` |
| Password eye button | Password changes from hidden to visible | Passed in `password visibility button toggles obscuring` |
| Valid signup | One loading spinner appears, followed by `Welcome, Morgan!` | Passed in `valid signup loads and opens personalized success` |
| Empty name sent to Success | Visitor returns to Welcome; `Welcome, !` never appears | Passed in `empty success name returns to the foyer` |
| Rapid double-tap | Only one Success screen is created | Passed in `rapid double-tap creates only one success screen` |
| Leave during loading | Welcome remains visible and no late navigation or error occurs | Passed in `leaving during loading does not navigate after disposal` |

Latest automated result: **9 tests passed and Flutter analysis reported no
issues.** Add emulator screenshots beside the three hostile cases in the Word
document before submitting.

## Ghost Hunt II answers

### The Deep-Linked Séance

I protected the ballroom by checking the name before showing any welcome message. If the name is blank or only spaces, I send the visitor back to the foyer and remove the bad path. I tested this by opening the Success screen with three spaces as the name. The test returned to “Enter If You Dare” and confirmed that “Welcome, !” never appeared. This protects the visitor from seeing a broken page even when the normal form is bypassed.

**Evidence to attach:** Screenshot of the foyer after the empty-name test and the
`empty success name returns to the foyer` test result.

### The Vampire's Double Bite

I used two protections against a fast double-tap. The button becomes unavailable during loading, and a separate yes-or-no guard rejects another submission before the screen can redraw. I tested this by tapping the submit action twice without waiting between taps. The app displayed one loading spinner and created only one Success screen. I kept the separate guard because the button alone can have a tiny timing gap before its new appearance is shown.

**Evidence to attach:** Screenshot of the loading state and the
`rapid double-tap creates only one success screen` test result.

### The Mansion Remembers Too Much

I did not store the password anywhere because this app does not need it after the form closes. If a password were saved as plain text, someone with access to a device backup or a modified device could read it. My storage policy is to keep the password only in the form while that screen is open. The form releases its text holders when the visitor leaves, and Task C adds no local storage package. I verified the project has no password-saving call and no `shared_preferences` dependency.

**Evidence to attach:** Screenshot of `pubspec.yaml` and the password controller's
cleanup in `signup_screen.dart`.

## Engineering trade-off and improvement

I chose to return an empty-name visitor to the foyer instead of showing a generic name. This adds a small navigation step, but it keeps the success message honest and avoids confirming a signup with missing information. My current two-second loading delay is useful for demonstrating safe waiting, although it makes automated tests slower. I would improve it by placing the signup work behind a small service that can finish immediately in tests. That would keep the same visitor experience while making the checks faster and easier to maintain.

## Contributions

I did the coding and reused code from previous submissions.

## Build and submission

Build the preferred release APK with:

```text
flutter build apk --release
```

The APK will be created at:

```text
build/app/outputs/flutter-apk/app-release.apk
```




