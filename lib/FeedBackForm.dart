import 'package:feedpage/NavigationPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feedpage/PopUps/popUpFeedbackPage.dart';
import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:feedpage/customDrawer.dart';
import 'Loading.dart';
import 'package:feedpage/globals.dart' as globals;

class FeedbackForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class, which holds data related to the form.
class MyCustomFormState extends State<FeedbackForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  final myControllerName = TextEditingController();
  final myControllerFeedback = TextEditingController();
  bool loading = false;
  bool sent = false;
  File image;

  void _showDialogSuccess() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Feedback was sent Successfully"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => NavigationPage()));
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogFailure() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Failed"),
          content: new Text("Feedback could not be submitted. Kindly try doing it again in sometime."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => NavigationPage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerName.dispose();
    myControllerFeedback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    print(loading);
    return loading
        ? Loading()
        :
    SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          centerTitle: true,
          title: Text(
            'Feedback',
          ),
        ),
        backgroundColor: Colors.blue[50],
        drawer: CustomDrawer(image: globals.currentUser.url),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: TextFormField(
                    autofocus: true,
                    controller: myControllerName,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter your full name',
                      labelText: 'Name (optional)',
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: TextFormField(
                      autofocus: false,
//                                autocorrect: true,
                      maxLines: null,
                      controller: myControllerFeedback,
                      decoration: InputDecoration(
                        hintText: "Please provide your feedback",
                        border: OutlineInputBorder(),
                        icon: const Icon(Icons.comment),
                        labelText: 'Feedback',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your feedback';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                image == null
                    ? Container()
                    : Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: Text(
                              "Preview",
                              style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context)
                                    .primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(
                                    8.0, 8, 15, 8),
                                padding:
                                EdgeInsets.only(bottom: 20.0),
                                child: Icon(Icons.image,
                                    color: Colors.black)),
                            Container(
                                padding:
                                EdgeInsets.only(bottom: 20.0),
                                width: MediaQuery.of(context)
                                    .size
                                    .width -
                                    57,
                                child: Image.file(image)),
                          ],
                        ),
                      ],
                    )),
                Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                    child: RaisedButton(
                      child: Text("Click to add Image"),
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PopUpFeedbackPage()));
                        print(result);
                        setState(() {
                          image = result;
                        });
                      },
                    ),
                  ),
                ),
//                CircleAvatar(
//                  backgroundImage: temp == null ? null : FileImage(image),
//                ),

                Center(
                  child: Container(
                      child: new RaisedButton(
                          child: const Text('Submit'),
                          onPressed: () async {
                            if (_formKey.currentState.validate() &&
                                image != null) {
                              String _username =
                                  "junk1234dds@gmail.com";
                              String _password =
                                  "dds@1234";

                              final smtpServer =
                              gmail(_username, _password);
                              // Creating the Gmail server
                              final toSend = "Name : " +
                                  myControllerName.text +
                                  "\nFeedback :" +
                                  myControllerFeedback.text;
                              // Create our email message.
                              final message = Message()
                                ..from = Address(_username)
                                ..recipients.add(
                                    'dudechubs@gmail.com') //recipent email
                                ..ccRecipients.addAll(['dev.moxaj@gmail.com', 'Saicharanhahaha@gmail.com']) //cc Recipents emails
//                            ..bccRecipients.add(Address('dudechubs@gmail.com')) //bcc Recipents emails
                                ..subject =
                                    'Feedback' //subject of the email
                                ..text = toSend
                                ..attachments.add(FileAttachment(
                                    image)); //body of the email

                              try {
                                setState(() {
                                  loading = true;
                                });
                                await send(message, smtpServer);
                                setState(() {
                                  loading = false;
                                });
                                _showDialogSuccess();
                              } on MailerException catch (e) {
                                _showDialogFailure();
                                //print if the email is not sent
                                // e.toString() will show why the email is not sending
                              }
                              print("Sent");
                            }
                          })),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
