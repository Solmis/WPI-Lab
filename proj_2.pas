{ Michal Soltysiak (nr indeksu: 347246)
  "L-system", program zaliczeniowy nr 2}
program Lsystem;

type tab = array of String;

{ Dlugosc slowa, dla ktorego przesuniecie wynosi 0, tzn. pierwszy znak informuje nas, z czego
  mamy zamienic, a drugi 'na co'. Przy zamianie jednego znaku na inny nie dokonujemy przesuniecia}
const PREFIX = 2;
//n - dlugosc wyprowadzenia, kolejne "maxy" - indeksy ostatnich elementow w poszczegolnych tablicach
var n, zastap_max, interp_max, epilog_max: Integer;
//s_max - indeks ostatniego znaku slowa
var s_max: LongInt;
var aksjomat: String;
{zastap - tablica zawiera opis L-systemu (kolejne linijki), np. zastap[0] = xyz, czyli x->yz
 interp - tablica zawiera interpretacje (w podobnej postaci jak powyzej)
 epilog - tablica zawiera linijki epilogu, ktore zostana wypisane na koncu}
var zastap, interp, epilog: tab;
//slowo - tablica zawiera kolejne znaki wyprowadzanego slowa
var slowo: array[1..100001] of Char;

{Procedura wczytuje kolejne linijki z wejscia do podanej tablicy, az napotka pusty wiersz.
Ustawia rowniez max, czyli numer indeksu ostatniego elementu}
procedure WczytajTablice(var max: Integer; var t: tab);
var s: String;
begin
  readln(s);
  max := 0;

  while Length(s) > 0 do begin
    //Powiekszamy tablice o 1 element, po zakonczeniu petli mamy tablice takiej wielkosci, jakiej potrzebujemy
    SetLength(t, max+1);
    t[max] := s;
    inc(max);
    readln(s);
  end;

  dec(max);
end;

{Procedura wczytuje dane wejsciowe (dlugosc wyprowadzenia, aksjomat,
 opis i interpretacje L-systemu oraz epilog), a takze wypisuje prolog
 Uzywane zmienne globalne: n, aksjomat, zastap_max, interp_max, epilog_max; tablice: zastap, interp, epilog}
procedure WczytajDane();
var wiersz: String;
begin
  readln(n);
  readln(aksjomat);

  WczytajTablice(zastap_max, zastap);

  readln(wiersz);
  while Length(wiersz) > 0 do begin
    writeln(wiersz);
    readln(wiersz);
  end;

  WczytajTablice(interp_max, interp);
  WczytajTablice(epilog_max, epilog);
end;

{Procedura odpowiada za wyprowadzenie slowa odpowiedniej dlugosci poczynajac od aksjomatu
 Uzywane zmienne globalne: s_max, aksjomat, n; tablice: zastap, slowo}
procedure RozwinSlowo();
var j, k, l, m, przes: LongInt;
var znak: Char;
  
  {Procedura przesuwa elementy tablicy o indeksach od i_p do i_k o l_elem elementow.
   Dla dodatniego l_elem przesuwa elementy na wieksze indeksy, a dla ujemnego na mniejsze.
   Uzywana zmienna (tablica) globalna: slowo}
  procedure PrzesunElementy(const i_p, i_k, l_elem: Integer);
  var i: Integer;
  begin
    if l_elem > 0 then for i := i_k downto i_p do slowo[i+l_elem] := slowo[i]
    else for i := i_p to i_k do slowo[i+l_elem] := slowo[i];
  end;

  begin
    s_max := Length(aksjomat);
    for j := 1 to s_max do slowo[j] := aksjomat[j]; //slowo zaczynamy wyprowadzac od aksjomatu

    //Za kazdym obrotem petli uzyskujemy nowe wyprowadzenie slowa (dlugosci 1, 2, ..., n)
    for j := 1 to n do begin
      k := 1;

      while k <= s_max do begin
      l := 0;
        while l <= zastap_max do begin
          znak := zastap[l, 1];
          //Szukamy w opisie L-systemu czym powinnismy zastapic znak slowa, ktory aktualnie rozpatrujemy
          if slowo[k] = znak then
          begin
            przes := Length(zastap[l])-PREFIX;
            PrzesunElementy(k+1, s_max, przes);
            s_max := s_max+przes;
            for m := 0 to przes do slowo[k+m] := zastap[l, m+PREFIX];
            l := zastap_max+1; //Wyjscie z petli po zastapieniu znaku
            k := k+przes; //Ustawiamy k tak, aby wskazywal na i-1, gdzie i to nastepny indeks do rozpatrzenia
          end;
        inc(l);
        end;
      inc(k);
      end;
    end;
  end;

{Procedura zamienia kolejne znaki slowa wedlug dotyczacych ich regul interpretacji
 Uzywane zmienne globalne: s_max, interp_max; tablice: interp, slowo}
procedure ZinterpretujSlowo();
var i: LongInt;
var j: Integer;
begin
  for i := 1 to s_max do begin
    j := 0;
    while j <= interp_max do begin
      //Szukamy reguly dotyczacej aktualnie rozpatrywanego znaku
      if slowo[i] = interp[j, 1] then
      begin
        writeln(Copy(interp[j], 2, Length(interp[j]))); //Wypisujemy substring, napis bez pierwszego znaku
        j := interp_max+1; //Wychodzimy z petli
      end;
      inc(j);
    end;
  end;
end;

{Procedura wypisuje z tablicy epilog, ktory zostal wczytany w procedurze WczytajDane()
Uzywane zmienne globalne: epilog, epilog_max}
procedure WypiszEpilog();
var i: Integer;
begin
  for i := 0 to epilog_max do writeln(epilog[i]);
end;

begin
  WczytajDane();
  RozwinSlowo();
  ZinterpretujSlowo();
  WypiszEpilog();
end.