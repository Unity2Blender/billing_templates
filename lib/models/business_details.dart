class BusinessDetails {
  final String businessName;
  final String phone;
  final String email;
  final String gstin;
  final String pan;
  final String state;
  final String district;
  final String businessAddress;

  BusinessDetails({
    required this.businessName,
    this.phone = '',
    this.email = '',
    this.gstin = '',
    this.pan = '',
    this.state = '',
    this.district = '',
    this.businessAddress = '',
  });
}
