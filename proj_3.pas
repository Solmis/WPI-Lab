// Michal Soltysiak (nr indeksu: 347246)
// "Kalkulator", program zaliczeniowy nr 3
program Kalkulator;

// MAX_BLOK - maksymalny indeks bloku
// MAX_BAJT - maksymalny indeks bajtu (16 bajtow indeksuje od 0 do 15)
// MAX_BAJT_WART - maksymalny indeks bajtu, ktory reprezentuje wartosc (w tym wypadku jest to 14)
const MAX_BLOK = 50;
      MAX_BAJT = 15;
      MAX_BAJT_WART = MAX_BAJT-1;

// Typ pamieci - w formie tablicy dwuwymiarowej
type pam = array[0..MAX_BLOK, 0..MAX_BAJT] of Integer;

// pamiec - pamiec kalkulatora
// wolny_blok - tablica, pod i-tym indeksem znajduje sie informacja, czy i-ty blok jest wolny (true, gdy wolny)
var pamiec: pam; 
    wolny_blok: array[1..MAX_BLOK] of Boolean;

// Procedura zerujaca pamiec
// Wykorzystywane zmienne globalne: pamiec, wolny_blok
procedure CzyscPamiec();
var i, j: Integer;
begin
  for i := 0 to MAX_BLOK do begin
    for j:= 0 to MAX_BAJT do pamiec[i, j] := 0;
  end;

  // Poczatkowo wszystkie bloki pamieci sa wolne
  for i := 1 to MAX_BLOK do wolny_blok[i] := true;
end;

// Funkcja szuka wolnego bloku o najmniejszym indeksie i zwraca wartosc tegoz indeksu
// Wykorzystywane zmienne globalne: pamiec, wolny_blok
function PrzydzielPamiec():Integer;
var i, j: Integer;
begin
  i := 1;

  while i <= MAX_BLOK do begin

    if wolny_blok[i] = true then
    begin
      wolny_blok[i] := false;
      for j := 0 to MAX_BAJT do pamiec[i, j] := 0;
      PrzydzielPamiec := i;
      // Wychodzimy z petli
      i := MAX_BLOK+1;
    end;
    inc(i);

  end;
end;

// "#" - wypisuje stan pamieci
// Wykorzystywane zmienne globalne: pamiec
procedure WypiszPamiec();
var i, j: Integer;
begin
  for i := 0 to MAX_BLOK do begin
    // Jesli liczba jest jednocyfrowa, to dodajemy spacje, by wyrownac do prawej
    if i < 10 then write(' ');
    write(i, ':');
    for j := 0 to MAX_BAJT do begin
      // Wyrownujemy do prawej - 2 odstepy w przypadku jednocyfrowych liczb i 1 dla dwucyfrowych
      if pamiec[i, j] < 10 then write(' ');
      if pamiec[i, j] < 100 then write(' ');
      write(' ', pamiec[i, j]);
    end;
    writeln('');
  end;
end;

// "@" - wypisuje wartosc zmiennej
// Wykorzystywane zmienne globalne: pamiec
procedure WypiszZmienna(const zmienna: Char);

// nr_bloku - aktualny numer bloku
// max - liczba blokow, w ktorych przechowywana jest zmienna
// kolejne_bloki - tablica zawierajaca na indeksach 1..max numery kolejnych blokow przechowujacych zmienna
// pierwszy - flaga, false dopoki nie napotka pierwszej niezerowej wartosci bajtu (idac od najbardziej znaczacych)
// akt_bajt - wartosc przechowywana przez bajt rozpatrywany w danym momencie
var nr_bloku, max, i, j, akt_bajt: Integer;
    kolejne_bloki: array [1..MAX_BLOK] of Integer;
    pierwszy: Boolean;
begin
  nr_bloku := pamiec[0, ord(zmienna)-ord('a')];
  kolejne_bloki[1] := nr_bloku;
  max := 1;
  pierwszy := false;

  if nr_bloku = 0 then writeln('0')
  else
  begin
    // Zapisywanie do tablicy numerow kolejnych blokow, w ktorych przechowywana jest zmienna
    while pamiec[nr_bloku, MAX_BAJT] <> 0 do begin
      nr_bloku := pamiec[nr_bloku, MAX_BAJT];
      inc(max);
      kolejne_bloki[max] := nr_bloku;
    end;

    // Sprawdzamy wszystkie bajty, zaczynajac od najbardziej znaczacych
    for i := max downto 1 do begin
      for j := MAX_BAJT_WART downto 0 do begin

        akt_bajt := pamiec[kolejne_bloki[i], j];

        // Jezeli jest to pierwszy napotkany bajt o niezerowej wartosci
        if (pierwszy = false) and (akt_bajt <> 0) then
        begin
          pierwszy := true;
          write(akt_bajt);
        end
        // Jezeli zaczelismy juz wypisywac liczbe, to zapisujemy wartosc w formie trzycyfrowej, z zerami wiodacymi
        else if pierwszy = true then
        begin
          if akt_bajt < 100 then write('0');
          if akt_bajt < 10 then write('0');
          write(akt_bajt);
        end;
      end;
    end;

    writeln('');

  end;
end;


// Procedura sprowadza nasza liczbe do poprawnej postaci (gdzie wartosci w bajtach wynosza mniej niz 1000)
// Wykorzystywane zmienne globalne: pamiec
procedure Normalizuj(const zmienna: Char);

// nr_bloku - numer aktualnie rozpatrywanego bloku
var nr_bloku, i: Integer;
begin
  nr_bloku := pamiec[0, ord(zmienna)-ord('a')];

    // Wykonujemy, dopoki pozostal nam jakis blok do sprawdzenia.
    // Dla bajtow od 0 do MAX_BAJT_WART-1 mozemy zwiekszac nastepny w tym samym bloku,
    // gdy zajdzie taka potrzeba, a dla MAX_BAJT_WART >= 1000 musimy zwiekszyc bajt o indeksie 0
    // w nastepnym bloku.
    while nr_bloku <> 0 do begin
      for i := 0 to MAX_BAJT_WART-1 do begin
        if pamiec[nr_bloku, i] >= 1000 then
        begin 
          inc(pamiec[nr_bloku, i+1]);
          pamiec[nr_bloku, i] := pamiec[nr_bloku, i]-1000;
        end;
      end;

      if pamiec[nr_bloku, MAX_BAJT_WART] >= 1000 then
      begin
        // Przydzielamy nowy blok dla zmiennej, gdy zachodzi taka potrzeba
        if pamiec[nr_bloku, MAX_BAJT] = 0 then pamiec[nr_bloku, MAX_BAJT] := PrzydzielPamiec();
        pamiec[nr_bloku, MAX_BAJT_WART] := pamiec[nr_bloku, MAX_BAJT_WART]-1000;
        nr_bloku := pamiec[nr_bloku, MAX_BAJT];
        inc(pamiec[nr_bloku, 0]);
      end
      else nr_bloku := pamiec[nr_bloku, MAX_BAJT];
    end;
end;

// "^" - dodaje 1 do wartosci zmiennej
// Wykorzystywane zmienne globalne: pamiec
procedure Zwieksz(const zmienna: Char);

// nr_bloku - numer aktualnie rozpatrywanego bloku 
// nr_przydz - zmienna pomocnicza
var nr_bloku, nr_przydz: Integer;
begin
  nr_bloku := pamiec[0, ord(zmienna)-ord('a')];

  // Jezeli zmienna nie ma przydzielonego bloku
  if nr_bloku = 0 then
  begin
    // Przydziel pamiec i zapisz 1
    nr_przydz := PrzydzielPamiec();
    pamiec[0, ord(zmienna)-ord('a')] := nr_przydz;
    pamiec[nr_przydz, 0] := 1;
  end
  else
  begin
    // Zwiekszamy liczbe o 1
    inc(pamiec[nr_bloku, 0]);
    // Jesli wartosc pierwszego bajtu jest rowna 1000, to nalezy "sprowadzic" liczbe do poprawnej postaci
    Normalizuj(zmienna);
  end;
end;

// "\" - nadaje zmiennej wartosc 0 i zwalnia pamiec
// Wykorzystywane zmienne globalne: pamiec, wolny_blok
procedure Zeruj(const zmienna: Char);
var nr_bloku, ostatni: Integer;
begin
  nr_bloku := pamiec[0, ord(zmienna)-ord('a')];

  if nr_bloku <> 0 then
  begin
    // Zwalniamy pamiec
    wolny_blok[nr_bloku] := true;
    ostatni := pamiec[nr_bloku, MAX_BAJT];

    while ostatni <> 0 do begin
      wolny_blok[ostatni] := true;
      ostatni := pamiec[ostatni, MAX_BAJT];
    end;

    pamiec[0, ord(zmienna)-ord('a')] := 0;
  end;
end;

// Procedura dodajaca wartosc drugiej zmiennej do pierwszej
// Wykorzystane zmienne globalne: pamiec
procedure Dodaj(const a, b: Char);
var blok_a, blok_b, i: Integer;
begin
  blok_a := pamiec[0, ord(a)-ord('a')];
  blok_b := pamiec[0, ord(b)-ord('a')];

  // Dodawanie zera nic nie zmienia. Jesli do zmiennej rownej 0 dodajemy niezerowa wartosc,
  // to musimy tej zmiennej przydzielic pamiec. Nastepnie dodajemy do siebie w kolejnych blokach
  // odpowiadajace sobie wartosci bajtow. Gdy zmienna, ktora dodajemy ma wiecej blokow niz zmienna,
  // do ktorej dodajemy, to tej drugiej przydzielamy kolejny blok i kontynuujemy dodawanie.

  if blok_b <> 0 then
  begin
    if blok_a = 0 then
    begin
      blok_a := PrzydzielPamiec();
      pamiec[0, ord(a)-ord('a')] := blok_a;
    end;

    while blok_b <> 0 do begin
      for i := 0 to 14 do pamiec[blok_a, i] := pamiec[blok_a, i]+pamiec[blok_b, i];
      blok_b := pamiec[blok_b, 15];

      if (blok_b <> 0) and (pamiec[blok_a, 15] = 0) then pamiec[blok_a, 15] := PrzydzielPamiec();
      blok_a := pamiec[blok_a, 15];
    end;

    // Poniewaz wartosci w poszczegolnych bajtach moga byc teraz >= 1000
    Normalizuj(a);

  end;
end;

// Procedura interpretujaca ciag znakow i wywolujaca zadane polecenia w odpowiedniej kolejnosci
// Wykorzystane zmienne globalne: pamiec
// len - dlugosc polecenia
// p - pierwszy znak polecenia
// g, esc, nawiasy, koniec - zmienne pomocnicze i poprawiajace czytelnosc
// counter - licznik, liczba wykonan danego podpolecenia
procedure Wykonaj(const polecenie: String);
var i, g, nawiasy, koniec, len: Integer;
    counter, j: QWord;
    esc: Boolean;
    p, znak: Char;
begin
  len := Length(polecenie);
  if len > 0 then
  begin
    p := polecenie[1];
    if p = '#' then WypiszPamiec()
    else if p = '@' then WypiszZmienna(polecenie[2])
    else if p = '^' then Zwieksz(polecenie[2])
    else if p = '\' then Zeruj(polecenie[2])
    else if (ord(p) >= ord('a')) and (ord(p) <= ord('p')) then Dodaj(p, polecenie[2])
    else if (ord(p) >= ord('2')) and (ord(p) <= ord('9')) then
    begin
      counter := ord(p)-ord('1')+1;
      i := 2;
      esc := false;

      //"Zliczanie" (mnozenie) sasiadujacych licznikow, by ograniczyc liczbe wywolan rekurencyjnych
      while (not esc) and (i <= len) do begin
        g := ord(polecenie[i])-ord('1')+1;
        if (g >= 2) and (g <= 9) then
        begin
          counter := counter*g;
          inc(i);
        end
        else esc := true;
      end;

      znak := polecenie[i];

      if znak = '#' then 
      begin
        for j := 1 to counter do Wykonaj('#');
        if i+1 <= len then Wykonaj(Copy(polecenie, i+1, len-i));
      end
      else if (znak = '@') or (znak = '^') or (znak = '\') or ((ord(znak) >= ord('a')) and (ord(znak) <= ord('p'))) then
      begin
        for j := 1 to counter do Wykonaj(Copy(polecenie, i, 2));
        if i+2 <= len then Wykonaj(Copy(polecenie, i+2, len-i-1));
      end
      else if znak = '(' then
      begin
        nawiasy := 1;
        koniec := i+1;

        // Sprawdzamy kolejne znaki, dopoki nawiasy sie nie "sparuja"
        while (nawiasy > 0) and (koniec <= len) do begin
          if polecenie[koniec] = '(' then inc(nawiasy)
          else if polecenie[koniec] = ')' then dec(nawiasy);
          inc(koniec);
        end;
        //Po wyjsciu z petli zmienna koniec ma wartosc o 1 wieksza niz indeks ')' ograniczajacego nasze podpolecenie

        if nawiasy = 0 then for j := 1 to counter do Wykonaj(Copy(polecenie, i+1, koniec-i-1));
        if koniec <= len then Wykonaj(Copy(polecenie, koniec, len-koniec+1));
      end;
    end;

    if (p = '#') or (p = '(') or (p = ')') then Wykonaj(Copy(polecenie, 2, len-1))
    else if (p = '@') or (p = '^') or (p = '\') or ((ord(p) >= ord('a')) and (ord(p) <= ord('p'))) then
      Wykonaj(Copy(polecenie, 3, len-2))
  end;
end;

var prompt: String;

begin
  prompt := 'niepusty';
  CzyscPamiec();

  // Wykonujemy kolejne wiersze, dopoki nie napotkamy wiersza pustego (wtedy program konczy dzialanie)
  while prompt <> '' do begin
    readln(prompt);
    Wykonaj(prompt);
  end;
end.