import 'package:flutter/material.dart';
import 'package:mobile/commons/config.dart';

const String notThisRelease = ""; //"_NOT_THIS_RELEASE";

const List<Map> DATA_ALL_ACTIONS = [
  {
    'key': "absence",
    'asset': "assets/img/izinIcon.png",
    'label': "İzin İşlemleri",
    'route': "/absence/actions",
    'module': "ABSENCE",
  },
  {
    'key': "expense",
    'asset': "assets/img/masrafIcon.png",
    'label': "Masraf İşlemleri",
    'route': "/expense/actions",
    'module': "EXPENSE",
  },
  {
    'key': "dayclosing",
    'asset': "assets/img/dayClosingIcon.png",
    'label': "Gün Kapanışı Uzatma Talebi",
    'route': "/dayclosing/actions",
    'module': "EOD"
  },
  {
    'key': "outsideTiming",
    'asset': "assets/img/disaridaGecirilenSureIcon.png",
    'label': "Dışarda Geçirilen Süre",
    'route': "/outside/actions" + notThisRelease,
    'module': "ARGE_PROJECT_USER"
  },
  {
    'key': "customerRequest",
    'asset': "assets/img/musteriIstegiIcon.png",
    'label': "Müşteri İsteği",
    'route': "/actions/customer-request/new",
    'module': "**"
  },
  {
    'key': "incident",
    'asset': "assets/img/olayVakaIcon.png",
    'label': "Olay / Vaka Bildir",
    'route': "/actions/incident/new",
    'module': "**"
  },
  {
    'key': "helpDesk",
    'asset': "assets/img/yardimMasasiIcon.png",
    'label': "Yardım Masası",
    'route': "/actions/help-desk",
    'module': "**",
  },
  {
    'key': "importantPhones",
    'asset': "assets/img/phoneIcon.png",
    'label': "Önemli Telefonlar",
    'route': "/actions/important-phones",
    'module': "*"
  },
  {
    'key': "investment",
    'asset': "assets/img/yatirimBilgileriIcon.png",
    'label': "Yatırım Bilgileri",
    'route': "/actions/investment-info",
    'module': "*"
  },
  {
    'key': "lunch",
    'asset': "assets/img/yemekListesiIcon.png",
    'label': "Yemek Listesi",
    'route': "/actions/lunch",
    'module': "*",
  },
  {
    'key': "shuttle",
    'asset': "assets/img/servisimIcon.png",
    'label': "Servisim",
    'route': "/actions/shuttle/list",
    'module': "*",
  },
  {
    'key': "inapp",
    'asset': Icon(Icons.mobile_screen_share, color: Config.COLOR_ORANGE),
    //"assets/img/servisimIcon.png",
    'label': "Diğer Uygulamalar",
    'route': "/actions/inapp",
    'module': "*"
  },
];

const List<Map> DATA_ACTIONS_ABOUT = [
  {
    'key': "about",
    'asset': "assets/img/aboutIcon.png",
    'label': "Hakkında",
    'route': "/actions/about",
  }
];

const List<Map> DATA_ABSENCE_ACTIONS = [
  {
    'key': "absence",
    'label': "İzin Oluştur",
    'route': "/absence/new",
    'module': "ABSENCE",
  },
  {
    'key': "batchAbsence",
    'label': "Toplu İzin Oluştur",
    'route': "/absence/batch/list",
    'module': "BATCH_ABSENCE",
  },
  {
    'key': "absenceHistory",
    'label': "İzin Geçmişim",
    'route': "/absence/history/list",
    'module': "ABSENCE",
  },
//  {
//    'key': "batchAbsenceHistory",
//    'label': "Toplu İzin Geçmişim",
//    'route': "/absence/batch/history",
//  },
  {
    'key': "absencePlanning",
    'label': "İzin Planlama",
    'route': "/absence/planning/actions",
    'module': "ABSENCE",
  },
  /*{
    'key': "absenceHistory_",
    'label': "Devamsızlık Tarihçesi",
    'route': "/absence/history/list",
  },*/
];

const List<Map> DATA_ABSENCE_PLANNING_ACTIONS = [
  {
    'key': "absencePlaningHoliday",
    'label': "Resmi Tatiller",
    'route': "/absence/planning/holidays",
  },
  {
    'key': "absencePlaningView",
    'label': "Planlanan İzinleri Gör",
    'route': "/absence/planning/list",
  },
  {
    'key': "absencePlaningNew",
    'label': "Yıllık İzin Planı Oluştur",
    'route': "/absence/planning/new",
  },
];
const List<Map> DATA_EXPENSE_ACTIONS = [
  {
    'key': "expense",
    'label': "Gider Raporu Oluştur",
    'route': "/expense/new/header" + notThisRelease,
  },
  {
    'key': "expenseHistory",
    'label': "Geçmiş Masraflarım",
    'route': "/expense/history/list" + notThisRelease,
  },
];

const List<Map> DATA_OUTSIDE_TIMING_ACTIONS = [
  {
    'key': "outsideTiming",
    'label': "Dışarda Geçirilen Süre Girişi",
    'route': "/outside/new",
  },
  {
    'key': "outsideTimingHistory",
    'label': "Dışarıda Geçirilen Süre Geçmişi",
    'route': "/outside/history/list",
  },
];

const List<Map> DATA_DAYCLOSING_TIMING_ACTIONS = [
  {
    'key': "dayclosing",
    'asset': "assets/img/dayClosingIcon.png",
    'label': "Gün K. Uzatma Talebi Oluştur",
    'route': "/dayclosing/new",
    'module': "*"
  },
  {
    'key': "dayclosing",
    'asset': "assets/img/dayClosingIcon.png",
    'label': "Gün K. Uzatma Talebi Geçmişi",
    'route': "/dayclosing/history/list",
    'module': "*"
  },
];