﻿Функция _37583_ALG_GET(Запрос)
	WebID = Запрос.ПараметрыURL["AlgWebID"];

	СтруктураВходящиеПараметры = Новый Структура;
	Для Каждого Параметр Из Запрос.ПараметрыЗапроса Цикл
		СтруктураВходящиеПараметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	СтруктураОтвет = Новый Структура("КодСостояния,ТелоОтвета", 200, "обработка метода GET ");

	ОбработатьЗапрос(WebID, СтруктураВходящиеПараметры, СтруктураОтвет);

	Ответ = Новый HTTPСервисОтвет(СтруктураОтвет.КодСостояния);
	Ответ.УстановитьТелоИзСтроки(СтруктураОтвет.ТелоОтвета, КодировкаТекста.UTF8);
	Ответ.Заголовки.Вставить("Content-Type", "text/html; charset=utf-8");
	Возврат Ответ;
КонецФункции

Процедура ОбработатьЗапрос(WebID, ВходящиеПараметры, Ответ)
//	Запрос = Новый Запрос;
//	Запрос.Текст =
//	"ВЫБРАТЬ ПЕРВЫЕ 1
//	|   _37583_ALG.Ссылка КАК Алгоритм
//	|ИЗ
//	|   Справочник.УИ_Алгоритмы КАК _37583_ALG
//	|ГДЕ
//	|   _37583_ALG.ИдентификаторHTTP = &WebID";
//
//	Запрос.УстановитьПараметр("WebID", WebID);
//
//	РезультатЗапроса = Запрос.Выполнить();
//	Если Не РезультатЗапроса.Пустой() Тогда
//		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//		ВыборкаДетальныеЗаписи.Следующий();
//		сОтвет = _37583_АлгоритмыСервер.ВыполнитьФункцию(ВыборкаДетальныеЗаписи.Алгоритм, ВходящиеПараметры);
//		Если ВходящиеПараметры["Отказ"] Тогда
//			Ответ.КодСостояния = 500;
//			Ответ.ТелоОтвета = ВходящиеПараметры.СообщениеОбОшибке;
//		Иначе
//			Если сОтвет["Результат"] = Неопределено Тогда
//				Ответ.КодСостояния = 500;
//				Ответ.ТелоОтвета = "Ошибка: не определен результат выполнения функции";
//
//			Иначе
//				Ответ.ТелоОтвета =сОтвет["Результат"];
//			КонецЕсли;
//		КонецЕсли;
//	Иначе
//		Ответ.КодСостояния = 404;
//		Ответ.ТелоОтвета = "Ошибка: не найден алгоритм";
//	КонецЕсли;
КонецПроцедуры
Функция _37583_ALG_POST(Запрос)

	WebID = Запрос.ПараметрыURL["AlgWebID"];
	SetParameter = Запрос.ПараметрыURL["SetParameter"];  // true or false

	СтруктураВходящиеПараметры = Новый Структура;
	Для Каждого Параметр Из Запрос.ПараметрыЗапроса Цикл
		СтруктураВходящиеПараметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	СтруктураОтвет = Новый Структура("КодСостояния,ТелоОтвета", 200, "обработка метода POST ");

	ОбработатьЗапрос(WebID, СтруктураВходящиеПараметры, СтруктураОтвет);

	Ответ = Новый HTTPСервисОтвет(СтруктураОтвет.КодСостояния);
	Ответ.УстановитьТелоИзСтроки(СтруктураОтвет.ТелоОтвета, КодировкаТекста.UTF8);
	Ответ.Заголовки.Вставить("Content-Type", "text/html; charset=utf-8");
	Возврат Ответ;
КонецФункции



#Область ПередачаДанных

Функция ПередачаДанныхPing(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.УстановитьТелоИзСтроки("OK");
	Возврат Ответ;
КонецФункции

Функция ПередачаДанныхSendFileAndUpload(Запрос)

	ОшибкаЗагрузки=Ложь;
	ОшибкаСервиса="";
	ЛогЗагрузки="";

	Попытка

		ИмяФайла = ПолучитьИмяВременногоФайла("zip");
		ДвоичныеДанныеОбмена=Запрос.ПолучитьТелоКакДвоичныеДанные();
		ДвоичныеДанныеОбмена.Записать(ИмяФайла);

		ИмяФайлаЛогаЗагрузки=ПолучитьИмяВременногоФайла("txt");

		Обработка = Обработки.УИ_УниверсальныйОбменДаннымиXML.Создать();
		Обработка.РежимОбмена = "Загрузка";
		Обработка.ИмяФайлаОбмена = ИмяФайла;
		Обработка.ИмяФайлаПротоколаОбмена=ИмяФайлаЛогаЗагрузки;
		Обработка.КодировкаФайлаПротоколаОбмена="UTF-8";
		Обработка.ВыполнитьЗагрузку();

		ОшибкаЗагрузки=Обработка.ФлагОшибки;
		УдалитьФайлы(ИмяФайла);

		ФайлЛога=Новый Файл(ИмяФайлаЛогаЗагрузки);
		Если ФайлЛога.Существует() Тогда
			ТекстЛога=Новый ТекстовыйДокумент;
			ТекстЛога.Прочитать(ИмяФайлаЛогаЗагрузки);

			ЛогЗагрузки=ТекстЛога.ПолучитьТекст();
			ТекстЛога=Неопределено;

			УдалитьФайлы(ИмяФайлаЛогаЗагрузки);

		КонецЕсли;
	Исключение
		ОшибкаСервиса = ОписаниеОшибки();
	КонецПопытки;

	СтруктураОтвета=Новый Структура;
	СтруктураОтвета.Вставить("ОшибкаСервиса", ОшибкаСервиса);
	СтруктураОтвета.Вставить("ОшибкаЗагрузки", ОшибкаЗагрузки);
	СтруктураОтвета.Вставить("ЛогЗагрузки", ЛогЗагрузки);

	ЗаписьJSON=Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();

	ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета);

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
	Ответ.УстановитьТелоИзСтроки(ЗаписьJSON.Закрыть());
	Возврат Ответ;

КонецФункции

#КонецОбласти