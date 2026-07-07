import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/controller/service_master_controller.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moon_design/moon_design.dart';
import 'package:uuid/uuid.dart';

class ServiceCreateEditView extends StatefulWidget {
  const ServiceCreateEditView({super.key});

  @override
  State<ServiceCreateEditView> createState() => _ServiceCreateEditViewState();
}

class _ServiceCreateEditViewState extends State<ServiceCreateEditView> {
  final ServiceMasterController controller =
      Get.find<ServiceMasterController>();
  final MainStore mainStore = Get.find<MainStore>();
  final AppLoaderController loader = Get.find<AppLoaderController>();

  final _formKey = GlobalKey<FormState>();

  late final String serviceId;
  bool isEditMode = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController gstPerController = TextEditingController();
  final TextEditingController discountPerController = TextEditingController();
  final TextEditingController registrationChargeController =
      TextEditingController();
  final TextEditingController totalDaysController = TextEditingController();
  final TextEditingController maxBookingController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  Map<String, dynamic>? selectedCategory;
  List<String> selectedTrainerIds = [];

  bool isTrial = false;
  bool withGST = false;
  bool fullPackageBookingOnly = false;
  bool isActive = true;

  XFile? pickedImageFile;

  @override
  void initState() {
    super.initState();

    final ServiceModel? service = Get.arguments as ServiceModel?;
    if (service != null) {
      isEditMode = true;
      serviceId = service.id;

      nameController.text = service.name;
      descriptionController.text = service.description;
      amountController.text = service.amount.toString();
      totalAmountController.text = service.totalAmount.toString();
      gstPerController.text = service.gstPer.toString();
      discountPerController.text = service.discountPer.toString();
      registrationChargeController.text = service.registrationCharge.toString();
      totalDaysController.text = service.totalDays.toString();
      maxBookingController.text = service.maxBooking.toString();
      imageUrlController.text = service.image;

      isTrial = service.isTrial;
      withGST = service.withGST;
      fullPackageBookingOnly = service.fullPackageBookingOnly;
      isActive = service.isActive;

      selectedTrainerIds = List<String>.from(service.trainerId);

      if (service.categoryId.isNotEmpty) {
        selectedCategory = {
          "id": service.categoryId,
          "name": service.categoryName,
        };
      }
    } else {
      serviceId = const Uuid().v4();
    }
  }

  void _autoCalculateTotalAmount() {
    final double amount = parseDouble(
      data: amountController.text,
      defaultValue: 0,
    );
    final int days = parseInt(data: totalDaysController.text, defaultInt: 0);
    if (amount > 0 && days > 0) {
      totalAmountController.text = (amount * days).toStringAsFixed(2);
    }
  }

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image;
    if (GetPlatform.isWindows) {
      FilePickerResult? f = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
      );
      if (f != null && f.xFiles.isNotEmpty) {
        image = f.xFiles[0];
      }
    } else {
      image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1020,
        maxWidth: 1380,
        imageQuality: 80,
      );
    }
    if (image != null) {
      setState(() {
        pickedImageFile = image;
      });
    }
  }

  Future<void> _save() async {
    if (nameController.text.trim().isEmpty) {
      showAlert("Please enter a service name", AlertType.error);
      return;
    }
    if (selectedCategory == null) {
      showAlert("Please select a category", AlertType.error);
      return;
    }

    try {
      loader.startLoading();

      final ServiceModel serviceModel = ServiceModel(
        id: serviceId,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        categoryId: selectedCategory!["id"] ?? "",
        categoryName: selectedCategory!["name"] ?? "",
        image: imageUrlController.text.trim(),
        isTrial: isTrial,
        withGST: withGST,
        fullPackageBookingOnly: fullPackageBookingOnly,
        isActive: isActive,
        amount: parseInt(data: amountController.text.trim(), defaultInt: 0),
        totalAmount: parseDouble(
          data: totalAmountController.text.trim(),
          defaultValue: 0,
        ),
        gstPer: parseDouble(
          data: gstPerController.text.trim(),
          defaultValue: 0,
        ),
        discountPer: parseDouble(
          data: discountPerController.text.trim(),
          defaultValue: 0,
        ),
        registrationCharge: parseDouble(
          data: registrationChargeController.text.trim(),
          defaultValue: 0,
        ),
        totalDays: parseInt(
          data: totalDaysController.text.trim(),
          defaultInt: 0,
        ),
        maxBooking: parseInt(
          data: maxBookingController.text.trim(),
          defaultInt: 0,
        ),
        trainerId: selectedTrainerIds,
        isPosted: false,
      );

      await controller.saveService(serviceModel, imageFile: pickedImageFile);
      Get.back();
    } catch (e) {
      showAlert("Error saving: $e", AlertType.error);
    } finally {
      loader.stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? "Edit Service" : "Add Service"),
          actions: [
            ButtonHelperG(
              onTap: _save,
              width: 80,
              shadow: const [],
              background: Colors.white,
              label: TextHelper(
                text: "Save",
                fontsize: 14,
                fontweight: FontWeight.w600,
                color: mainStore.theme.value.HeadColor,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 120,
                            height: 120,
                            color: Colors.blueGrey.shade50,
                            child: pickedImageFile != null
                                ? Image.file(
                                    File(pickedImageFile!.path),
                                    fit: BoxFit.cover,
                                  )
                                : imageUrlController.text.isNotEmpty
                                ? Image.network(
                                    imageUrlController.text,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, _, __) => const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                    ),
                                  )
                                : const Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.blueGrey,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.photo_library),
                          label: const Text("Pick Image"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                mainStore.theme.value.mediumShadeColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),

                  // Service Information
                  TextHelper(
                    text: "Service Info",
                    fontsize: 14,
                    fontweight: FontWeight.w600,
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "Name:",
                        width: 90,
                        fontweight: FontWeight.w600,
                        showRequired: true,
                      ),
                      Expanded(
                        child: TextBox(
                          controller: nameController,
                          placeholder: "e.g., Physiotherapy standard",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "Category:",
                        width: 90,
                        fontweight: FontWeight.w600,
                        showRequired: true,
                      ),
                      Expanded(
                        child: DropDownHelperG(
                          uniqueKey: "categorySelectDropdown",
                          placeHolder: "Select Category",
                          items: controller.categories,
                          value: selectedCategory,
                          height: 40,
                          listHeight: 150,
                          isSearchEnable: true,
                          onValueChange: (v) {
                            setState(() {
                              selectedCategory = v;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHelper(
                        text: "Description:",
                        width: 90,
                        fontweight: FontWeight.w600,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 80,
                          child: TextAreaBox(
                            controller: descriptionController,
                            placeholder: "Enter service description...",
                            height: 80,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(),

                  // Pricing & Days Configuration
                  TextHelper(
                    text: "Price & Settings",
                    fontsize: 14,
                    fontweight: FontWeight.w600,
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "Amount/Sess:",
                        width: 110,
                        fontweight: FontWeight.w600,
                      ),
                      Expanded(
                        child: TextBox(
                          controller: amountController,
                          keyboard: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          placeholder: "0",
                          onValueChange: (v) => _autoCalculateTotalAmount(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "Total Days:",
                        width: 110,
                        fontweight: FontWeight.w600,
                      ),
                      Expanded(
                        child: TextBox(
                          controller: totalDaysController,
                          keyboard: TextInputType.number,
                          placeholder: "0",
                          onValueChange: (v) => _autoCalculateTotalAmount(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "Total Amount:",
                        width: 110,
                        fontweight: FontWeight.w600,
                      ),
                      Expanded(
                        child: TextBox(
                          controller: totalAmountController,
                          keyboard: TextInputType.number,
                          placeholder: "0.00",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "Discount %:",
                        width: 110,
                        fontweight: FontWeight.w600,
                      ),
                      Expanded(
                        child: TextBox(
                          controller: discountPerController,
                          keyboard: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          placeholder: "0.00",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "GST %:",
                        width: 110,
                        fontweight: FontWeight.w600,
                      ),
                      Expanded(
                        child: TextBox(
                          controller: gstPerController,
                          keyboard: TextInputType.number,
                          placeholder: "0",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "Regis. Charge:",
                        width: 110,
                        fontweight: FontWeight.w600,
                      ),
                      Expanded(
                        child: TextBox(
                          controller: registrationChargeController,
                          keyboard: TextInputType.number,
                          placeholder: "0",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "Max Booking:",
                        width: 110,
                        fontweight: FontWeight.w600,
                      ),
                      Expanded(
                        child: TextBox(
                          controller: maxBookingController,
                          keyboard: TextInputType.number,
                          placeholder: "0",
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(
                        text: "Image URL:",
                        width: 110,
                        fontweight: FontWeight.w600,
                      ),
                      Expanded(
                        child: TextBox(
                          controller: imageUrlController,
                          placeholder: "https://...",
                          onValueChange: (v) {
                            setState(() {}); // refresh local image preview
                          },
                        ),
                      ),
                    ],
                  ),

                  // Option Switches
                  const SizedBox(height: 6),
                  Card(
                    elevation: 0,
                    color: Colors.blueGrey.shade50.withAlpha(120),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextHelper(
                                text: "Is Trial Service",
                                fontweight: FontWeight.w500,
                              ),
                              MoonSwitch(
                                value: isTrial,
                                onChanged: (v) => setState(() => isTrial = v),
                                switchSize: MoonSwitchSize.xs,
                                activeTrackColor: Colors.green,
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextHelper(
                                text: "With GST",
                                fontweight: FontWeight.w500,
                              ),
                              MoonSwitch(
                                value: withGST,
                                onChanged: (v) => setState(() => withGST = v),
                                switchSize: MoonSwitchSize.xs,
                                activeTrackColor: Colors.green,
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextHelper(
                                text: "Full Package Booking Only",
                                fontweight: FontWeight.w500,
                              ),
                              MoonSwitch(
                                value: fullPackageBookingOnly,
                                onChanged: (v) =>
                                    setState(() => fullPackageBookingOnly = v),
                                switchSize: MoonSwitchSize.xs,
                                activeTrackColor: Colors.green,
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextHelper(
                                text: "Active Status",
                                fontweight: FontWeight.w500,
                              ),
                              MoonSwitch(
                                value: isActive,
                                onChanged: (v) => setState(() => isActive = v),
                                switchSize: MoonSwitchSize.xs,
                                activeTrackColor: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(),

                  // Trainers Assignment Section
                  MoonAccordion(
                    autofocus: false,
                    hasContentOutside: true,
                    expandedBackgroundColor:
                        mainStore.theme.value.lowShadeColor,
                    backgroundColor: Colors.blueGrey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    showBorder: false,
                    childrenPadding: const EdgeInsets.all(10),
                    shadows: const [],
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FontAwesomeIcons.userDoctor, size: 16),
                        const SizedBox(width: 8),
                        TextHelper(
                          text:
                              "Assign Trainers (${selectedTrainerIds.length})",
                          fontsize: 13.5,
                          fontweight: FontWeight.w600,
                        ),
                      ],
                    ),
                    children: [
                      if (controller.trainers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No active trainers found"),
                        ),
                      ...controller.trainers.map((trainer) {
                        final isAssigned = selectedTrainerIds.contains(
                          trainer.id,
                        );
                        return Row(
                          children: [
                            MoonCheckbox(
                              activeColor: Colors.green,
                              value: isAssigned,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    selectedTrainerIds.add(trainer.id);
                                  } else {
                                    selectedTrainerIds.remove(trainer.id);
                                  }
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextHelper(
                                text: trainer.name,
                                fontsize: 12.5,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
