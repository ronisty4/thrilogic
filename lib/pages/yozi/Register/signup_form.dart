// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:thrilogic_shop/API/json_future/json_future.dart';
import 'package:thrilogic_shop/API/object_class/auth.dart';
import 'package:wave_transition/wave_transition.dart';
import '../../../services/already_have_an_account_acheck.dart';
import 'package:thrilogic_shop/services/styles.dart';
import 'package:thrilogic_shop/pages/yozi/login_page.dart';
import 'package:thrilogic_shop/services/icon_assets.dart';

class SignUpForm extends StatelessWidget {
  SignUpForm({
    Key? key,
  }) : super(key: key);

  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController notelp = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController konfirmasi = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: nama,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            cursorColor: Warna().font,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Masukan nama kamu",
              hintStyle: Font.style(fontSize: 16),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Assets.registerIcon('profile'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: Warna().font,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Masukan email kamu",
                hintStyle: Font.style(fontSize: 16),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Assets.registerIcon('sms'),
                ),
              ),
            ),
          ),
          TextFormField(
            controller: notelp,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            cursorColor: Warna().font,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Masukkan No.Tlpn kamu",
              hintStyle: Font.style(fontSize: 16),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Assets.registerIcon('call'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: password,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: Warna().first,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Masukkan password",
                hintStyle: Font.style(fontSize: 16),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Assets.registerIcon('lock'),
                ),
              ),
            ),
          ),
          TextFormField(
            controller: konfirmasi,
            textInputAction: TextInputAction.done,
            obscureText: true,
            cursorColor: Warna().first,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Konfirmasi password",
              hintStyle: Font.style(fontSize: 16),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Assets.registerIcon('lock'),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () async {
              Register register = await JsonFuture().register(
                name: nama.text,
                email: email.text,
                handphone: notelp.text,
                password: password.text,
                passwordConfirmation: konfirmasi.text,
              );
              snackBar(context, text: register.info!);
              if (register.code == '00') {
                Navigator.pushReplacement(
                  context,
                  WaveTransition(
                    duration: const Duration(milliseconds: 700),
                    center: const FractionalOffset(0.9, 0.0),
                    child: const LoginScreen(),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              backgroundColor: Warna().first,
              fixedSize: const Size(500, 50),
            ),
            child: Text(
              "Sign Up".toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.pushReplacement(
                context,
                WaveTransition(
                  duration: const Duration(milliseconds: 700),
                  center: const FractionalOffset(0.9, 0.0),
                  child: const LoginScreen(),
                ),
              );
            },
          ),
          const SizedBox(
            height: defaultPadding * 2,
          ),
        ],
      ),
    );
  }
}
