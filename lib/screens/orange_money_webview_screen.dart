import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Affiche la page de paiement Orange Money (WebPay) dans une WebView.
///
/// Détecte le retour (return_url / cancel_url configurés côté backend)
/// et notifie l'écran appelant via [onPaymentReturned] pour démarrer
/// le polling de statut.
class OrangeMoneyWebViewScreen extends StatefulWidget {
  final String paymentUrl;

  const OrangeMoneyWebViewScreen({super.key, required this.paymentUrl});

  @override
  State<OrangeMoneyWebViewScreen> createState() =>
      _OrangeMoneyWebViewScreenState();
}

class _OrangeMoneyWebViewScreenState extends State<OrangeMoneyWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasReturned = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            _checkReturnUrl(url);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            _checkReturnUrl(url);
          },
          onNavigationRequest: (request) {
            _checkReturnUrl(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  /// Détecte si l'URL correspond au retour configuré côté backend
  /// (ORANGE_MONEY_RETURN_URL / ORANGE_MONEY_CANCEL_URL).
  /// On revient simplement à l'écran précédent dans ce cas — c'est
  /// l'écran Paiement qui démarre alors le polling de statut.
  void _checkReturnUrl(String url) {
    if (_hasReturned) return;
    final isReturn = url.contains('/paiement/retour') ||
        url.contains('/paiement/annule');
    if (isReturn) {
      _hasReturned = true;
      // Petite latence pour laisser la page se charger visuellement
      // avant de fermer la WebView.
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pop(context, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        // Si l'utilisateur ferme manuellement, on remonte `false`
        // (pas de confirmation détectée).
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          title: const Text('Paiement Orange Money'),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
              ),
          ],
        ),
      ),
    );
  }
}