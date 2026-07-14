import 'package:firebaseauth/login_signupScreen/view/loginscreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class VerificationScreen2 extends StatefulWidget {
  final String phoneNumber;
  final String? email;
  
  const VerificationScreen2({
    Key? key, 
    required this.phoneNumber,
    this.email,
  }) : super(key: key);

  @override
  State<VerificationScreen2> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen2> 
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = 
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = 
      List.generate(4, (_) => FocusNode());
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _shakeController;
  late AnimationController _successController;
  int _remainingSeconds = 60;
  Timer? _timer;
  bool _isVerifying = false;
  bool _showSuccess = false;
  int _attemptCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTimer();
    
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController.forward();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _shakeController.dispose();
    _successController.dispose();
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // Only allow numeric input
    if (value.isNotEmpty && !RegExp(r'^[0-9]$').hasMatch(value)) {
      _controllers[index].text = '';
      return;
    }

    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // Auto-verify when all fields are filled
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyCode();
    }
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();
    
    if (code.length != 4) {
      _showErrorAnimation();
      return;
    }

    setState(() {
      _isVerifying = true;
      _attemptCount++;
    });
    
    // Simulate API call with random success/failure
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate verification result (80% success rate)
    final isSuccess = _attemptCount <= 2 || DateTime.now().millisecond % 5 != 0;
    
    if (isSuccess) {
      await _showSuccessAnimation();
      if (mounted) {
        _navigateToSuccess();
      }
    } else {
      setState(() => _isVerifying = false);
      _showErrorAnimation();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid verification code'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showErrorAnimation() async {
    await _shakeController.forward();
    await _shakeController.reverse();
  }

  Future<void> _showSuccessAnimation() async {
    setState(() => _showSuccess = true);
    await _successController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToSuccess() {
    // Navigate to next screen
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Verification Successful!'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _resendCode() {
    if (_remainingSeconds == 0) {
      setState(() {
        _remainingSeconds = 60;
        _attemptCount = 0;
      });
      _startTimer();
      
      // Clear all fields and refocus first field
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('New code sent to your device'),
          backgroundColor: Colors.blue.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  String get _formattedPhoneNumber {
    final number = widget.phoneNumber;
    if (number.length > 4) {
      return '+${number.substring(0, number.length - 10)} ******${number.substring(number.length - 4)}';
    }
    return number;
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, 
                  color: Colors.white.withOpacity(0.8), size: 18),
              const SizedBox(width: 8),
              Text(
                'Verification Info',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoItem('Sent to:', _formattedPhoneNumber),
          if (widget.email != null) 
            _buildInfoItem('Email:', widget.email!),
          _buildInfoItem('Code expires in:', '$_remainingSeconds seconds'),
          _buildInfoItem('Attempts:', '$_attemptCount/3'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF8075FF),
              const Color(0xFF6C63FF),
              Colors.white,
            ],
            stops: const [0.0, 0.4, 0.7],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Header with Back Button
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, 
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Step 2 of 2',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Animated Icon
                  _buildAnimatedIcon(),
                  
                  const SizedBox(height: 40),
                  
                  // Title & Subtitle
                  _buildTitleSection(),
                  
                  const SizedBox(height: 30),
                  
                  // Info Section
                  _buildInfoSection(),
                  
                  const SizedBox(height: 20),
                  
                  // OTP Input Boxes
                  _buildOTPSection(),
                  
                  const SizedBox(height: 40),
                  
                  // Timer and Resend
                  _buildResendSection(),
                  
                  const SizedBox(height: 30),
                  
                  // Verify Button
                  _buildVerifyButton(),
                  
                  const SizedBox(height: 30),
                  
                  // Help Section
                  _buildHelpSection(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    if (_showSuccess) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.green.shade600],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 60,
              color: Colors.green,
            ),
          ),
        ),
      );
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: Curves.elasticOut,
      )),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.95, end: 1.05).animate(_pulseController),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phonelink_lock_rounded,
              size: 60,
              color: Color(0xFF8075FF),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return FadeTransition(
      opacity: _slideController,
      child: Column(
        children: [
          const Text(
            'Verify Your Identity',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Enter the 4-digit code sent to your device\n${_formattedPhoneNumber}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPSection() {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final shakeOffset = _shakeController.value * 8;
        return Transform.translate(
          offset: Offset(
            shakeOffset * (1 - _shakeController.value) * 2, 
            0
          ),
          child: Column(
            children: [
              Text(
                'ENTER VERIFICATION CODE',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOTPBox(index)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOTPBox(int index) {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideController.value) * 50 * (index + 1)),
          child: Opacity(
            opacity: _slideController.value,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _focusNodes[index].hasFocus
                      ? const Color(0xFF8075FF)
                      : Colors.grey.withOpacity(0.3),
                  width: _focusNodes[index].hasFocus ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _focusNodes[index].hasFocus
                        ? const Color(0xFF8075FF).withOpacity(0.4)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: _focusNodes[index].hasFocus ? 25 : 8,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8075FF),
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) => _onChanged(value, index),
                onTap: () => setState(() {}),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResendSection() {
    return _remainingSeconds > 0
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, 
                      color: Colors.white.withOpacity(0.8), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Resend code in $_remainingSeconds seconds',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _remainingSeconds / 60,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _remainingSeconds > 10 ? Colors.green.shade400 : Colors.orange.shade400,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          )
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.white.withOpacity(0.8)),
                    const SizedBox(width: 8),
                    Text(
                      'Ready for new code',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _resendCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF8075FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    'Resend',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
  
 Widget _buildVerifyButton() {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: () {
        // Navigate to ShopkeeperLoginScreen when button is clicked
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login2()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF8075FF),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Verify Code'),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
    ),
  );
}
  Widget _buildHelpSection() {
    return Column(
      children: [
        TextButton(
          onPressed: _remainingSeconds == 0 ? _resendCode : null,
          child: Text(
            'Having trouble receiving the code?',
            style: TextStyle(
              color: _remainingSeconds == 0 
                  ? Colors.white 
                  : Colors.white.withOpacity(0.4),
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: [
            _buildHelpChip(
              icon: Icons.phone_rounded,
              text: 'Call me',
              onTap: () {},
            ),
            _buildHelpChip(
              icon: Icons.email_rounded,
              text: 'Email me',
              onTap: () {},
            ),
            _buildHelpChip(
              icon: Icons.support_agent_rounded,
              text: 'Help',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHelpChip({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: Colors.white.withOpacity(0.8)),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}