﻿&НаКлиенте
Процедура Обновить(Команда)
	Если ОбновлениеЧерезСкачиваниеФайлаПоставки Тогда
		ОбновитьЧерезСкачиваниеФайла();
	Иначе
		ОбновитьЧерезОбновлениеРасширения();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте 
Процедура ОбновитьЧерезСкачиваниеФайла()
	ИмяФайла=УИ_ОбщегоНазначенияКлиентСервер.ИмяФайлаСкачивания();
	МассивИмениФайла=УИ_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИмяФайла, ".");
	РасширениеФайла=МассивИмениФайла[МассивИмениФайла.Количество()-1];
	
	
	ДиалогВыбораФайла=Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогВыбораФайла.Расширение=РасширениеФайла;
	ДиалогВыбораФайла.Фильтр="Файл новой версии универсальных инструментов|*."+РасширениеФайла;
	ДиалогВыбораФайла.МножественныйВыбор=Ложь;
	ДиалогВыбораФайла.ПолноеИмяФайла=ИмяФайла;
	ДиалогВыбораФайла.Показать(Новый ОписаниеОповещения("ОбновитьЧерезСкачиваниеФайлаЗаверешениеВыбораИмениФайла", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте 
Процедура ОбновитьЧерезСкачиваниеФайлаЗаверешениеВыбораИмениФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанные=СкачанныеДвоичныеДанныеОбновления();
	Если ДвоичныеДанные=Неопределено Тогда
		Сообщить("Не удалось скачать обновление с сайта обновления");
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДвоичныеДанные)<>Тип("ДвоичныеДанные") Тогда
		Возврат;
	КонецЕсли;
		
	ДвоичныеДанные.НачатьЗапись(Новый ОписаниеОповещения("ОбновитьЧерезСкачиваниеФайлаЗаверешениеЗаписиФайла", ЭтотОбъект), ВыбранныеФайлы[0]);
	
КонецПроцедуры	

&НаКлиенте 
Процедура ОбновитьЧерезСкачиваниеФайлаЗаверешениеЗаписиФайла(ДополнительныеПараметры) Экспорт
	ПоказатьПредупреждение(, "Файл успешно скачан");
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЧерезОбновлениеРасширения()
	РезультатьОбновления=РезультатОбновленияЧерезРасширениеНаСервере();

	Если РезультатьОбновления = Неопределено Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбновитьЧерезОбновлениеРасширенияЗавершение", ЭтотОбъект),
			"Обновление успешно применено. Для использования изменений нужно перезапустить сеанс. Перезапустить?",
			РежимДиалогаВопрос.ДаНет);
	Иначе
		УИ_ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка применения обновления " + РезультатьОбновления);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЧерезОбновлениеРасширенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	ЗавершитьРаботуСистемы(Ложь, Истина);
КонецПроцедуры

&НаСервере
Функция СкачанныеДвоичныеДанныеОбновления()
	Ответ=УИ_КоннекторHTTP.Get(URLАктуальногоРелиза);

	Если Ответ.КодСостояния > 300 Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат Ответ.Тело;
	
КонецФункции

&НаСервере
Функция РезультатОбновленияЧерезРасширениеНаСервере()
	ДвоичныеДанные=СкачанныеДвоичныеДанныеОбновления();
	
	Если ДвоичныеДанные=Неопределено Тогда
		Возврат "Не удалось скачать файл обновления с сервера";
	КонецЕсли;

	Если ТипЗнч(ДвоичныеДанные) <> Тип("ДвоичныеДанные") Тогда
		Возврат "Неправильный формат файла облновления";
	КонецЕсли;

	Отбор = Новый Структура;
	Отбор.Вставить("Имя", "УниверсальныеИнструменты");

	НайденныеРасширения = РасширенияКонфигурации.Получить(Отбор);

	Если НайденныеРасширения.Количество() = 0 Тогда
		Возврат "Не обнаружено расширение Универсальные инструменты";
	КонецЕсли;

	НашеРасширение = НайденныеРасширения[0];
	
	// Проверим возможность применения расширения

	РезультатПроверки=НашеРасширение.ПроверитьВозможностьПрименения(ДвоичныеДанные, Ложь);

	Если РезультатПроверки.Количество() > 0 Тогда
		СообщениеОбОшибках="";
		Для Каждого ИнформацияОПроблемеПримененияРасширенияКонфигурации Из РезультатПроверки Цикл
			СообщениеОбОшибках=СообщениеОбОшибках + ?(ЗначениеЗаполнено(СообщениеОбОшибках), Символы.ПС, "") + "Ошибка применения расширения "
				+ ИнформацияОПроблемеПримененияРасширенияКонфигурации.Описание;
		КонецЦикла;

		Возврат СообщениеОбОшибках;
	КонецЕсли;

	РезультатОбновления=Неопределено;
	Попытка
		НашеРасширение.Записать(ДвоичныеДанные);
	Исключение
		РезультатОбновления=ОписаниеОшибки();
	КонецПопытки;

	Возврат РезультатОбновления;

КонецФункции

&НаСервере
Процедура ЗаполнитьТекущуюВерсию()
	ТекущаяВерсия = УИ_ОбщегоНазначенияКлиентСервер.Версия();
	ВариантПоставки=УИ_ОбщегоНазначенияКлиентСервер.ВариантПоставки();
	ИмяФайлаСкачки=УИ_ОбщегоНазначенияКлиентСервер.ИмяФайлаСкачивания();
	ОбновлениеЧерезСкачиваниеФайлаПоставки=Не СтрЗаканчиваетсяНа(НРег(ИмяФайлаСкачки), "cfe");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАктуальнуюВерсиюИОписаниеИзменений()
//Получаем список всех релизов
	АдресЗапроса = "https://api.github.com/repos/cpr1c/tools_ui_1c/releases";
	ИмяФайлаСкачки=УИ_ОбщегоНазначенияКлиентСервер.ИмяФайлаСкачивания();
	
	МассивРелизов = УИ_КоннекторHTTP.GetJson(АдресЗапроса);

	МаксимальныйРелиз = "0.0.0";
	СоответствиеОписанияРелизов = Новый Соответствие;

	Для Каждого ТекРелиз Из МассивРелизов Цикл
		ВерсияТекРелиза = СтрЗаменить(ТекРелиз["tag_name"], "v", "");

		Если УИ_ОбщегоНазначенияКлиентСервер.СравнитьВерсииБезНомераСборки(ВерсияТекРелиза, ТекущаяВерсия) > 0 Тогда
			СоответствиеОписанияРелизов.Вставить(ВерсияТекРелиза, ТекРелиз);
		КонецЕсли;

		Если УИ_ОбщегоНазначенияКлиентСервер.СравнитьВерсииБезНомераСборки(ВерсияТекРелиза, МаксимальныйРелиз) <= 0 Тогда
			Продолжить;
		КонецЕсли;

		МаксимальныйРелиз = ВерсияТекРелиза;
		ВложенияРелиза = ТекРелиз["assets"];
		Если ВложенияРелиза = Неопределено Тогда
			URLАктуальногоРелиза = "";
		Иначе
			Для Каждого ТекВложение Из ВложенияРелиза Цикл
				ИмяФайлаРелиза = ТекВложение["name"];

				Если СтрНайти(НРег(ИмяФайлаРелиза), НРег(ИмяФайлаСкачки)) = 0 Тогда
					Продолжить;
				КонецЕсли;

				URLАктуальногоРелиза=ТекВложение["browser_download_url"];
				Прервать;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;

	АктуальнаяВерсия = МаксимальныйРелиз;

	ОписаниеИзменений = "";
	Для Каждого РелизОписания Из СоответствиеОписанияРелизов Цикл
		ОписаниеИзменений = ОписаниеИзменений + РелизОписания.Ключ + Символы.ПС;
		ОписаниеИзменений = ОписаниеИзменений + РелизОписания.Значение["body"] + Символы.ПС;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьНеобходимостьОбновления()
	Если УИ_ОбщегоНазначенияКлиентСервер.СравнитьВерсииБезНомераСборки(АктуальнаяВерсия, ТекущаяВерсия) > 0 Тогда
		НеобходимостьОбновления = Истина;
	КонецЕсли;

	Элементы.ФормаОбновить.Видимость = НеобходимостьОбновления;
	Элементы.ОписаниеИзменений.Видимость = НеобходимостьОбновления;
	
	Если ОбновлениеЧерезСкачиваниеФайлаПоставки Тогда
		Элементы.ФормаОбновить.Заголовок="Скачать";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьТекущуюВерсию();
	ЗаполнитьАктуальнуюВерсиюИОписаниеИзменений();
	УстановитьНеобходимостьОбновления();
КонецПроцедуры