import 'package:e_commerce_app/view_models/payment_methods_cubit/payment_methods_cubit.dart';
import 'package:e_commerce_app/views/widgets/main_button.dart';
import 'package:e_commerce_app/views/widgets/new_card_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewCardPage extends StatefulWidget {
  const AddNewCardPage({super.key});

  @override
  State<AddNewCardPage> createState() => _AddNewCardPageState();
}

class _AddNewCardPageState extends State<AddNewCardPage> {
  final cardNumberController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cardExpiryDateController = TextEditingController();
  final cardCvvController = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<PaymentMethodsCubit>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Card'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                NewCardInfo(
                  title: 'Card Number',
                  prefixIcon: Icons.credit_card,
                  hintText: 'Enter card number',
                  controller: cardNumberController,
                ),
                const SizedBox(height: 36.0),
                NewCardInfo(
                  title: 'Card Holder Name',
                  prefixIcon: Icons.person,
                  hintText: 'Enter card holder name',
                  controller: cardHolderNameController,
                ),
                const SizedBox(height: 36.0),
                NewCardInfo(
                  title: 'Expiry Date',
                  prefixIcon: Icons.date_range,
                  hintText: 'Enter expiry date',
                  controller: cardExpiryDateController,
                ),
                const SizedBox(height: 36.0),
                NewCardInfo(
                  title: 'CVV Code',
                  prefixIcon: Icons.password,
                  hintText: 'Enter cvv',
                  controller: cardCvvController,
                ),
                const Spacer(),
                BlocConsumer<PaymentMethodsCubit, PaymentMethodsState>(
                  bloc: cubit,
                  listenWhen: (previous, current) =>
                      current is AddNewCardSuccess ||
                      current is AddNewCardFailure,
                  listener: (context, state) {
                    if (state is AddNewCardSuccess) {
                      Navigator.pop(context);
                    } else if (state is AddNewCardFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                        ),
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is AddNewCardLoading ||
                      current is AddNewCardSuccess ||
                      current is AddNewCardFailure,
                  builder: (context, state) {
                    if (state is AddNewCardLoading) {
                      return const ElevatedButton(
                        onPressed: null,
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return MainButton(
                      title: 'Add Card',
                      onTap: () {
                        if (key.currentState!.validate()) {
                          cubit.addNewCard(
                            cardNumberController.text,
                            cardHolderNameController.text,
                            cardExpiryDateController.text,
                            cardCvvController.text,
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
