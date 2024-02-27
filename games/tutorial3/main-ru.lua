-- $Name:Обучение$

instead_version "1.6.0"

require "dash" -- '--' replace :)
require "para" -- be more "Russian"
require "quotes"

game.act = 'Не получается.';
game.inv = "Гм.. Не то..";
game.use = 'Не сработает...';

game.pic = 'instead.png';

set_music('instead.ogg');

main = room {
	nam = 'Обучение',
	act = function() -- only one vobj, no check, just goto
		walk('r1');
	end,
	dsc = txtc("Добро пожаловать в режим обучения INSTEAD.")..[[^^
	Игра состоит из сцен. Каждая сцена игры имеет описание,
	состоящее из статической и динамической части. Динамическая часть включает объекты,
	персонажей и т.д. С динамической частью игрок может взаимодействовать с помощью мыши, 
	нажимая на подсвеченные ссылки.^^

	Данная сцена называется "Обучение" и сейчас Вы читаете статическую часть её описания.
	Единственным объектом сцены является объект "Дальше", который Вы видите внизу текста.
	Итак, для продолжения обучения Вы можете нажать на "Дальше".]],
	obj = { 
		vobj('continue', '{Дальше}'),
	},
};

paper = obj {
	nam = 'бумага',
	dsc = 'Первое, что Вы замечаете в комнате -- {листок бумаги}.',
	tak = 'Вы взяли бумагу.',
	var { seen = false, haswriting = false },
	inv = function(s)
		if here() == r2 then
			s.seen = true;
		end
		if not s.haswriting then
			return 'Чистый лист клетчатой бумаги. Похоже, его вырвали из тетради.';
		end
		p 'Лист клетчатой бумаги, на котором написано Ваше имя.';
	end,
	used = function(s, w)
		if w == pencil and here() == r4 then
			s.haswriting = true;
			p 'Вы пишете на листке своё имя.';
		end
	end,
};

pencil = obj {
	nam = 'карандаш',
	dsc = 'На полу лежит {карандаш}.',
	tak = 'Вы подобрали карандаш.',
	var { seen = false },
	inv = function(s)
		if here() == r2 then
			s.seen = true;
		end
		p 'Обычный деревянный карандаш.';
	end,
};

r1 = room {
	nam = 'Урок 1',
	enter = code [[ lifeon('r1') ]],
	life = function(s)
		if not have 'paper' or not have 'pencil' then
			return
		end
		put(vway('continue',
		[[Отлично!^Вы скорее всего заметили, что статическая часть описания сцены
		исчезла, уступив место описанию предметов, которые Вы взяли.
		Чтобы снова посмотреть полное описание сцены, можно нажать на её
		название, отображаемое в верхней части окна -- "Урок 1". Кроме того,
		можно нажать клавишу F5 на клавиатуре, результат будет таким же.^^
		{Дальше}]], 'r2'));
		lifeoff('r1');
	end,
	dsc = [[Урок 1. Взаимодействие с объектами^^
		Продолжим урок. Сейчас Вы находитесь в комнате. Возьмите оба предмета, 
		которые Вы видите. Напомним, что для этого Вы можете просто
		использовать мышь. Если Вам удобнее пользоваться клавиатурой -- можно
	выбрать нужный предмет с помощью клавиш со стрелками и нажать "Ввод" для
	взаимодействия с ним.]],
	obj = { 'paper', 'pencil'},
};

r2 = room {
	nam = 'Урок 2',
	enter = code [[ lifeon('r2') ]],
	life = function(s)
		if not paper.seen or not pencil.seen then
			return
		end
		put(vway("continue", "Хорошо!^^{Дальше}", 'r3'));
		lifeoff('r2');
	end,
	dsc = [[Урок 2. Использование инвентаря - Часть I^^
		Теперь у Вас появились предметы, которые можно использовать или изучать.
		Для этого предназначен инвентарь. Вы можете посмотреть на любой предмет 
		инвентаря дважды щелкнув мышью по этому предмету. То же самое можно 
		сделать с помощью клавиатуры: нажмите "Tab", чтобы переключиться на панель 
		инвентаря, выберите нужный предмет и дважды
		нажмите "Ввод". Чтобы вернуться назад к описанию сцены, нажмите "Tab" еще раз.^^

		Итак, посмотрите на бумагу. Затем, повторите эту операцию с карандашом.]],
};

apple = obj {
	nam = 'яблоко',
	dsc = 'На столе лежит {яблоко}.',
	tak = 'Вы взяли яблоко со стола.',
	var { knife = false },
	inv = function(s)
		if here() == r4 then
			remove(s, me());
			return 'Вы съедаете яблоко.';
		end
		p 'Выглядит аппетитно.';
	end,
};

desk = obj {
	nam = 'стол',
	dsc = 'На этом уроке вы видите деревянный {письменный стол}.',
	var { haswriting = false, seen = false },
	act = function(s)
		if s.haswriting then
			s.seen = true;
			return 'Большой дубовый письменный стол. На столешнице видна мелкая надпись карандашом: "Lorem Ipsum".';
		end
		p 'Большой дубовый письменный стол.';
	end,
	used = function(s, w)
		if w == pencil and not s.haswriting then
			s.haswriting = true;
			p 'Вы пишете на столешнице несколько букв.';
		end
	end,
	obj = { 'apple' },
};

r3 = room {
	nam = 'Урок 3',
	enter = code [[ lifeon('r3') ]],
	life = function(s)
		if not desk.seen or not have('apple') then
			return
		end
		put(vway("continue", "^^{Дальше}", 'r4'));
		lifeoff('r3');
	end,
	dsc = [[Урок 3. Использование инвентаря - Часть II^^
		Вы можете действовать предметами инвентаря на другие предметы сцены или инвентаря. 
		В этой комнате вы увидите стол. Попробуйте воздействовать карандашом на стол.^^ 

		Для этого нажмите мышью на карандаш, а затем на стол. То же самое можно сделать
		с помощью клавиатуры: используя клавиши "Tab", "Ввод" и "стрелки".^^
  
		Затем посмотрите на стол. И не забудьте взять яблоко, оно нам пригодится в следующем уроке.]],
	obj = { 'desk' },
};
 
r4 = room {
	nam = 'Урок 4',  
	enter = function()
		apple.knife = false;
		lifeon('r4');
	end,
	life = function(s)
		if not paper.haswriting or have('apple') then
			return
		end
		put(vway("continue", "Хорошо.^^{Дальше}", 'r5'));
		lifeoff('r4');
	end,
	dsc = [[Урок 4. Использование инвентаря - Часть III^^
		Хорошо, теперь изучим еще несколько действий с предметами.^^
	
		Во-первых, напишите что-нибудь на бумаге. Для этого нажмите мышью 
		на карандаш, а затем на бумагу. После этого вы можете посмотреть
		на бумагу, чтобы увидеть вашу запись.^^
	
		Во-вторых, съешьте яблоко, которое Вы взяли со стола в предыдущей комнате. 
		Для этого дважды щелкните по яблоку в инвентаре.^^

		Все описанные действия можно выполнить с помощью клавиатуры так же, 
		как показано в предыдущем уроке.]],
};

r5 = room {
	nam = 'Урок 5',
	exit = function(s, t)
		if t ~= r6 then
			return 'Этот урок мы уже прошли.^ Пожалуйста, перейдите на урок 6.', false;
		end
	end,
	dsc = [[Урок 5. Перемещение - Часть I^^
		Теперь изучим переходы между комнатами. В этой комнате Вы видите пять 
		дополнительных ссылок с номерами уроков. Перейдите на урок 6. ^^

		Для этого нажмите мышью на соответствующую ссылку. Вы также можете воспользоваться
		клавиатурой -- выберите нужную ссылку с помощью клавиш со стрелками 
		и нажмите "Ввод" для перехода.]],
	way = { 'r1', 'r2', 'r3', 'r4', 'r6'},
};

r6 = room {
	nam = 'Урок 6',
	exit = function(s, t)
		if t ~= theend then
			p 'Этот урок мы уже прошли.^ Пожалуйста, перейдите на последний урок.'
			return false; -- same as return "text", false
		end
	end,
	dsc = [[Урок 6. Перемещение - Часть II^^
		Теперь перейдите на последний урок.]],
	way = { 'r1', 'r2', 'r3', 'r4', 'r5', 'theend'},
};

theend = room {
	nam = 'Последний урок',
	dsc = [[Вы можете выбирать игру, сохранять и загружать её состояние и выполнять 
		другие действия с помощью меню. Для вызова меню нажмите клавишу "Esc" или 
		нажмите мышью на символ меню (справа снизу).^^
		Теперь Вы готовы к игре. Удачи!!!^^
		Игры для INSTEAD можно скачать здесь: ]]..txtu("https://instead-hub.github.io")..[[^^
		В обучении использован трек "Instead game-engine" от svenzzon.]],
	obj = { vway('keys', 'Посмотреть {список клавиш}.', 'help')},
};

help = room {
	nam = 'Список клавиш',
	dsc = [[
	Esc - Вызов меню;^
	Alt+Q - Выход;^
	Alt+Enter - Полноэкранный/оконный режим;^
	F5 - Обновление сцены;^
	Пробел/Backspace - Прокрутка описания сцены;^
	Tab/Shift+Tab - Переключение между активными зонами;^
	PgUp/PgDn - Прокрутка активной зоны;^
	Стрелки влево/вправо - Выбор ссылок в активной зоне;^
	F2 - Сохранение игры;^
	F3 - Загрузка игры;^
	F8 - Быстрое сохранение игры;^
	F9 - Быстрая загрузка игры.^^

	Клавиши, поведение которых зависит от выбранного режима клавиатуры
	(см. Меню -> Настройки -> Режим клавиатуры):^^

	Стрелки вверх/вниз:^
	 - В режиме "Прокрутка": прокрутка активной зоны;^
	 - В режиме "Ссылки": выбор ссылок в активной зоне;^
	 - В режиме "Умный": одновременно выбор ссылок и прокрутка активной зоны.^^

	Стрелки вверх/вниз + Shift или Alt:^
	 - В режиме "Прокрутка": выбор ссылок в активной зоне;^
	 - В режиме "Ссылки": прокрутка активной зоны;^
	 - В режиме "Умный": прокрутка активной зоны.
	]],
	obj = { vway('cmdline', 'Посмотреть {параметры командной строки}.', 'help2')},
};

help2 = room {
	nam = 'Параметры командной строки',
	dsc = [[
	-nosound - запуск без звука;^
	-debug - отладочный режим для разработчика игр;^
	-theme <тема> - выбор темы;^
	-game <игра> - выбор игры;^
	-themespath <путь> - дополнительный путь к темам;^
	-gamespath <путь> - дополнительный путь к играм;^
	-windows - оконный режим;^
	-fullscreen - полноэкранный режим;^
	-noautosave - отключить автосохранение/автозагрузку;^
	-encode <game.lua> [encoded.lua] - закодировать исходный текст lua (используйте doencfile для загрузки такого файла);^
	-mode [ШИРИНАxВЫСОТА] - установить разрешение.
	]],
	obj = { vway('keys', 'Посмотреть {список клавиш}.', 'help')},
};
