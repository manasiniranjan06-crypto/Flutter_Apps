
// ─── SUBSCRIPTION PLANS ───────────────────────────────────────────────────────
import 'package:shared_preferences/shared_preferences.dart';

enum SubscriptionPlan { free, pro, elite }

class SubscriptionManager {
  static const String _planKey = 'subscription_plan';
  static const String _historyKey = 'subscription_history';

  // Free: Beginner + Easy, max 5 questions
  // Pro: All levels, max 15 questions
  // Elite: All levels, unlimited (20) questions
  static const int freeMaxQuestions = 5;
  static const int proMaxQuestions = 15;
  static const int eliteMaxQuestions = 20;

  static const List<String> freeLevels = ['Beginner', 'Easy'];
  static const List<String> proLevels = ['Beginner', 'Easy', 'Medium', 'Hard'];
  static const List<String> eliteLevels = ['Beginner', 'Easy', 'Medium', 'Hard'];

  static Future<SubscriptionPlan> getCurrentPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_planKey) ?? 'free';
    switch (val) {
      case 'pro':
        return SubscriptionPlan.pro;
      case 'elite':
        return SubscriptionPlan.elite;
      default:
        return SubscriptionPlan.free;
    }
  }

  static Future<void> upgradePlan(SubscriptionPlan plan, String paymentId, double amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_planKey, plan.name);

    // Save to history
    final history = prefs.getStringList(_historyKey) ?? [];
    final entry =
        '${DateTime.now().toIso8601String()}|${plan.name}|$paymentId|$amount';
    history.insert(0, entry);
    await prefs.setStringList(_historyKey, history);
  }

  static Future<List<Map<String, String>>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    return history.map((e) {
      final parts = e.split('|');
      return {
        'date': parts.isNotEmpty ? parts[0] : '',
        'plan': parts.length > 1 ? parts[1] : '',
        'paymentId': parts.length > 2 ? parts[2] : '',
        'amount': parts.length > 3 ? parts[3] : '0',
      };
    }).toList();
  }

  static bool canAccessLevel(SubscriptionPlan plan, String level) {
    switch (plan) {
      case SubscriptionPlan.free:
        return freeLevels.contains(level);
      case SubscriptionPlan.pro:
      case SubscriptionPlan.elite:
        return true;
    }
  }

  static int maxQuestions(SubscriptionPlan plan) {
    switch (plan) {
      case SubscriptionPlan.free:
        return freeMaxQuestions;
      case SubscriptionPlan.pro:
        return proMaxQuestions;
      case SubscriptionPlan.elite:
        return eliteMaxQuestions;
    }
  }
}

///
///import 'package:shared_preferences/shared_preferences.dart';

// enum SubscriptionPlan { free, pro, elite }

// extension SubscriptionPlanX on SubscriptionPlan {
//   String get label {
//     switch (this) {
//       case SubscriptionPlan.pro:   return 'Pro';
//       case SubscriptionPlan.elite: return 'Elite';
//       case SubscriptionPlan.free:  return 'Free';
//     }
//   }

//   String get badgeLabel {
//     switch (this) {
//       case SubscriptionPlan.pro:   return 'PRO';
//       case SubscriptionPlan.elite: return 'ELITE';
//       case SubscriptionPlan.free:  return 'FREE';
//     }
//   }
// }

// class SubscriptionManager {
//   static const _planKey    = 'subscription_plan';
//   static const _historyKey = 'subscription_history';

//   static Future<SubscriptionPlan> getCurrentPlan() async {
//     final prefs = await SharedPreferences.getInstance();
//     final val = prefs.getString(_planKey) ?? 'free';
//     switch (val) {
//       case 'pro':   return SubscriptionPlan.pro;
//       case 'elite': return SubscriptionPlan.elite;
//       default:      return SubscriptionPlan.free;
//     }
//   }

//   static Future<List<Map<String, String>>> getHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     final history = prefs.getStringList(_historyKey) ?? [];
//     return history.map((e) {
//       final parts = e.split('|');
//       return {
//         'date':      parts.isNotEmpty   ? parts[0] : '',
//         'plan':      parts.length > 1   ? parts[1] : '',
//         'paymentId': parts.length > 2   ? parts[2] : '',
//         'amount':    parts.length > 3   ? parts[3] : '0',
//       };
//     }).toList();
//   }
// }
///