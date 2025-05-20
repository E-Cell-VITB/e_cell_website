import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/auth/widgets/custom_text_feild.dart';
import 'package:e_cell_website/services/providers/event_register_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  List<Map<String, dynamic>> textfeilds;

  RegisterForm({required this.textfeilds, super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllers =
        List.generate(widget.textfeilds.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _register_provider=Provider.of<EventRegisterProvider>(context);
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 18),
        child: SizedBox(
          height: (widget.textfeilds.length) * 80 + 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LinearGradientText(
                  child: Text(
                "Register Now",
                style: Theme.of(context).textTheme.headlineMedium,
              )),
              SizedBox(
                height: 5,
              ),
              Text(
                "Join the event now",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(
                height: 20,
              ),
              ...List.generate(widget.textfeilds.length, (index) {
                final field = widget.textfeilds[index]['fieldName'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Textfeild(context, field, _controllers[index]),
                );
              }),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async{
                    Map<String, String> formData = {};
                    for (int i = 0; i < _controllers.length; i++) {
                      formData[widget.textfeilds[i]['fieldName']] =
                          _controllers[i].text?? '';
                    }
                    print(formData);
                   await  _register_provider.Register("Sandeep", formData);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: linerGradient),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Textfeild(
      BuildContext context, String feild, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: feild,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: "Enter ${feild}",
        hintStyle: const TextStyle(color: Color.fromARGB(255, 72, 72, 72)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 0.5,
            color: secondaryColor.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 1.0,
            color: secondaryColor,
          ),
        ),
      ),
    );
  }
}
