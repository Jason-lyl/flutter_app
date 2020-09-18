import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/**
 * @author: Jason
 * @create_at: Sep 14, 2020
 */


final LocaleReducer = combineReducers<Locale>([
  TypedReducer<Locale, RefreshLocaleAction>(_refresh),
]);

Locale _refresh(Locale locale, RefreshLocaleAction action) {
  locale = action.locale;
  return locale;
}

class RefreshLocaleAction {
  final Locale locale;

  RefreshLocaleAction(this.locale);
}