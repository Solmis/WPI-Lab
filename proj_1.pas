{ Michal Soltysiak (nr indeksu: 347246)
  "Connect6" }
program Connect6;

//deklaracja zmiennych i stalych globalnych oraz typow
type plansza = array[1..19, 1..19] of Char;
var moja_plansza: plansza;
const ROZMIAR = 19;
var pozostale_pola: Integer; //wolne pola na planszy, poczatkowo 361 (ROZMIAR^2)
var polecenie, komunikat: String; //polecenie - to, co wpisze gracz, komunikat - tekst wyswietlany po wypisaniu planszy
var gracz: Char; //zmienna okresla czyj ruch jest w danym momencie, 'X' - gracz X, 'O' - gracz O

//procedura wypelnia plansze kropkami (wolne pola)
procedure UtworzPlansze();
var i, j: Integer;
begin
  for i := 1 to ROZMIAR do begin
    for j := 1 to ROZMIAR do moja_plansza[i, j] := '.';
  end;
end;

//procedura wypisuje aktualny stan planszy oraz komunikat (np. czyj jest ruch, kto wygral)
procedure WypiszPlansze(const informacja: string);
var i, j: Integer;
begin
  writeln('--------------------------------------+');
 
  //numery wierszy maleja, gdyz maleja takze litery (s,r,...,a), Aa to moja_plansza[1,1]
  for i := ROZMIAR downto 1 do begin
    //wypisywanie kolejnych liter od s do a (97 to numer znaku 'a' w kodzie ASCII, w pierwszym obrocie petli otrzymujemy 115, czyli 's')
  	write(chr(96+i));

  	for j := 1 to ROZMIAR-1 do write(moja_plansza[i, j], ' ');
  	writeln(moja_plansza[i, ROZMIAR], '|');
  end;

  for i := 1 to ROZMIAR do write(' ', chr(64+i)); //65 to 'A' w ASCII, w pierwszym obrocie petli 64+i = 65, a nastepne znaki to kolejne litery (majuskula)
  writeln('|');

  writeln(informacja);
end;

//Procedura wykonuje ruch, gdy jest to mozliwe. W przypadku, gdy jedno z podanych pol jest zajete, procedura nie robi nic.
procedure WykonajRuch(const A, b, C, d: Integer);
//w1, w2 - numery wierszy tablicy, odpowiednio pierwszego i drugiego punktu
//k1, k2 - numery kolumn tablicy, odpowiednio pierwszego i drugiego punktu
var w1, w2, k1, k2: Integer;
begin
  w1 := b-96; //odejmujemy liczbe znakow w ASCII wystepujacych przed 'a', wtedy numer 'a' daje nam wiersz pierwszy, 'b' drugi itd.
  k1 := A-64; //odejmujemy 64, wiec dla numeru 'A' = 65 otrzymujemy 1, dla 'B' - 2 itd.

  if (C = 0) and (d = 0) then //jezeli wykonujemy pierwszy ruch
  begin
    if moja_plansza[w1, k1] = '.' then 
	begin
	  moja_plansza[w1, k1] := 'X';
	  dec(pozostale_pola);
	  gracz := 'O';
	  komunikat := 'gracz O';
	end;
  end
  else //jezeli wykonujemy jeden z nastepnych ruchow
  begin
    w2 := d-96; //to samo, co wyzej robimy dla drugiego punktu
    k2 := C-64;

    if (moja_plansza[w1, k1] = '.') and (moja_plansza[w2, k2] = '.') then
    begin
      moja_plansza[w1, k1] := gracz;
      moja_plansza[w2, k2] := gracz;
      pozostale_pola := pozostale_pola-2;

      //po wykonaniu prawidlowego ruchu nastepuja zmiana gracza
      if gracz = 'X' then
      begin
        gracz := 'O';
        komunikat := 'gracz O';
      end
      else 
	  begin
        gracz := 'X';
        komunikat := 'gracz X';
	    end;
      end;
    end;
end;

//procedura sprawdza poprawnosc polecenia oraz wywoluje procedure WykonajRuch, gdy stwierdzi, ze zapis polecenia jest poprawny
procedure ZinterpretujPolecenie(const komenda: String);
var A, b, C, d: Integer; //numery w ASCII pierwszych 4 znakow komendy (oczekujemy komendy w postaci Ab lub AbCd)
begin
  //Przypisanie kodow pierwszego i drugiego znaku komendy
  A := ord(komenda[1]);
  b := ord(komenda[2]);
  //W przypadku ruchu pierwszego C i d beda rowne 0, czyli nie bedzie drugiego punktu
  C := 0;
  d := 0;

  //Jesli pierwszy punkt zostal okreslony przez litere A-S jako pierwsza oraz litere a-s jako druga
  if (A >= 65) and (A <= 83) and (b >= 97) and (b <= 115) then
  begin
    //Jesli gracz podal jeden punkt i jest to poczatek gry
    if (Length(komenda) = 2) and (pozostale_pola = ROZMIAR*ROZMIAR) then WykonajRuch(A, b, C, d)
    //Jesli gracz podal dwa punkty i nie jest to poczatek gry
    else if (Length(komenda) = 4) and (pozostale_pola < ROZMIAR*ROZMIAR) then
    begin
      C := ord(komenda[3]);
      d := ord(komenda[4]);

      if (C <> A) or (b <> d) then //Jesli gracz nie wskazal w poleceniu 2 razy tego samego punktu
      begin
        if (C >= 65) and (C <= 83) and (d >= 97) and (d <= 115) then WykonajRuch(A, b, C, d);
      end;
    end;
  end;
end;

//Funkcja sprawdza, czy jest na planszy pod rzad przynajmniej 6 znakow podanego gracza w jednym wierszu / kolumnie
//Zwraca true, gdy znajdzie 'szostke' lub false, gdy nie znajdzie
function Sprawdz(const spr_gracz: Char; poziomo: Boolean): Boolean;
//w_linii - ile jest znakow gracza (ktory ostatnio sie poruszyl) wstecz, pod rzad, w tym samym wierszu/kolumnie
var i, j, w_linii: Integer;
begin
  Sprawdz := false;

  for i := 1 to ROZMIAR do begin
    w_linii := 0;
    for j := 1 to ROZMIAR do begin

      if poziomo = true then
      begin
        if moja_plansza[i, j] = spr_gracz then inc(w_linii)
        else w_linii := 0;
        end
        else
        begin
          if moja_plansza[j, i] = spr_gracz then inc(w_linii)
          else w_linii := 0;
        end;
 		  
        if w_linii = 6 then Sprawdz := true;
        end;
    end;
end;

//Funkcja sprawdza ukosne 'linie' planszy (w obu kierunkach, tzn. takie jak z pola Aa do Ss oraz jak z pola Sa do As).
//Zwraca true, gdy w jakiejkolwiek ukosnej 'linii' napotka 6 znakow sprawdzanego gracza pod rzad.
function SprawdzNaUkos(const spr_gracz: Char): Boolean;
var i, j, w_linii: Integer; //w linii na ukos ile znakow gracza pod rzad
begin
  SprawdzNaUkos := false;

  {6 to minimalna liczba znakow, ktora musi ulozyc gracz, by zwyciezyc
  w zwiazku z tym nie warto sprawdzac 'ukosnych linii' krotszych niz 6 pol
  Sa 4 petle wewnetrzne, poniewaz kazda sprawdza linie ukosne od kazdego rogu planszy do przekatnej
  Pierwsza sprawdza linie od lewego gornego rogu planszy, druga - od prawego gornego,
  trzecia - od przekatnej do prawego dolnego rogu, a czwarta od przekatnej do lewego dolnego rogu planszy}
  for i := ROZMIAR-6+1 downto 1 do begin
    w_linii := 0;
    for j := 0 to ROZMIAR-i do begin
      if moja_plansza[i+j, j+1] = spr_gracz then inc(w_linii)
      else w_linii := 0;
      if w_linii = 6 then SprawdzNaUkos := true;
    end;

    w_linii := 0;
    for j := ROZMIAR downto i do begin //ROZMIAR-(ROZMIAR-i) = i
      if moja_plansza[i+ROZMIAR-j, j] = spr_gracz then inc(w_linii)
      else w_linii := 0;
      if w_linii = 6 then SprawdzNaUkos := true;
    end;
  end;

  for i := 2 to ROZMIAR-6+1 do begin
    w_linii := 0;
    for j := 0 to ROZMIAR-i do begin
      if moja_plansza[j+1, i+j] = spr_gracz then inc(w_linii)
      else w_linii := 0;
      if w_linii = 6 then SprawdzNaUkos := true;
    end;
  end;

  for i := ROZMIAR-1 downto 6 do begin
    w_linii := 0;
    for j := 1 to i do begin
      if moja_plansza[j, i-j+1] = spr_gracz then inc(w_linii)
      else w_linii := 0;
      if w_linii = 6 then SprawdzNaUkos := true;
    end;
  end;
end;

//procedura sprawdza, czy ktorys z graczy ulozyl 6 swoich znakow w jednej linii
procedure SprawdzPlansze();
var sprawdzany_gracz: Char;
begin
  //Nie moze zostac jedno wolne pole, poniewaz wszystkich pol jest 361, a pierwszy ruch zajmuje jedno, wiec pozostaje 360,
  //z ktorych ubywa po 2. Gdy gracz wygra i wykorzystane zostana wszystkie pola, to komunikat 'remis' zostanie nadpisany.
  if pozostale_pola = 0 then komunikat := 'remis';

  //Po wykonaniu ruchu, przed sprawdzeniem, gracz sie zmienia, wiec nalezy sprawdzac gracza poprzedniego
  if gracz = 'X' then sprawdzany_gracz := 'O'
  else sprawdzany_gracz := 'X';

  if Sprawdz(sprawdzany_gracz, true) = false then //Sprawdzanie, czy w jakims wierszu jest 6 poszukiwanych znakow pod rzad
  begin
    if Sprawdz(sprawdzany_gracz, false) = false then //Sprawdzanie, czy w jakiejs kolumnie jest 6 poszukiwanych znakow pod rzad
    begin
      if SprawdzNaUkos(sprawdzany_gracz) = true then komunikat := 'wygral '+sprawdzany_gracz;
    end
    else komunikat := 'wygral '+sprawdzany_gracz;
  end
  else komunikat := 'wygral '+sprawdzany_gracz;
end;

begin
  UtworzPlansze();
  pozostale_pola := ROZMIAR*ROZMIAR; //wszystkie pola sa wolne
  gracz := 'X';
  komunikat := 'gracz X';
  WypiszPlansze(komunikat);

  while pozostale_pola > 0 do begin
    readln(polecenie);

    //Jesli gracz poda komende pusta, to wychodzimy z petli <=> konczymy gre
    if polecenie = '' then pozostale_pola := 0
    else if Length(polecenie) >= 2 then 
    begin
      //Jesli polecenie jest dlugosci przynajmniej 2 znakow, to mozemy sprawdzic te znaki
      ZinterpretujPolecenie(polecenie);
      //Sprawdzamy, czy wykonany ruch konczy gre
      SprawdzPlansze();
      WypiszPlansze(komunikat);

      //Jesli ktorys z graczy wygral, wychodzimy z petli <=> konczymy gre
      if komunikat[1] = 'w' then pozostale_pola := 0;
    end
    else WypiszPlansze(komunikat);

  end;
end.