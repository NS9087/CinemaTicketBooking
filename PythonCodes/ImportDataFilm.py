from googletrans import Translator
from somefunctions import open_csv_file, write_sql_data

film_orig = '''INSERT INTO CinemaTicketBooking.dbo.FilmOrig (TitleHU, TitleOrig, FilmCategory, ReleaseYear,
                         DurationMin, ProdCountry, Director, Stars, FilmRatingType) VALUES (?,?,?,?,?,?,?,?,?)'''

film_normal = '''INSERT INTO CinemaTicketBooking.dbo.Film (TitleHU, TitleOrig, ReleaseYear, DurationMin,
                    FilmRatingTypeID, FilmPriceTypeID) VALUES (?,?,?,?,?,?)'''

film_type = '''INSERT INTO CinemaTicketBooking.dbo.DictFilmType (FilmTypeName, FilmTypeNameE, FilmTypeCode) 
                    VALUES (?,?,?)'''

film_film_type = '''INSERT INTO CinemaTicketBooking.dbo.FilmFilmType (FilmID, FilmTypeID) VALUES (?,?)'''

film_film_cou = '''INSERT INTO CinemaTicketBooking.dbo.FilmCountry (FilmID, CountryCode) VALUES (?,?)'''

film_film_director = '''INSERT INTO CinemaTicketBooking.dbo.FilmDirector (FilmID, Director) VALUES (?,?)'''

film_film_star = '''INSERT INTO CinemaTicketBooking.dbo.FilmStar (FilmID, Star) VALUES (?,?)'''

film_film_rate = '''INSERT INTO CinemaTicketBooking.dbo.DictFilmRatingType (FilmRatingTypeName, FilmRatingTypeNameE, 
                    FilmRatingTypeCode) VALUES (?,?,?)'''


def create_film_type(my_type_in):
    c = my_type_in
    translator = Translator()
    for i, row in enumerate(my_type_in):
        # result = translator.translate(row[0], src='hu', dest='en').text
        # c[i].append(result)
        c[i].append(str(row[0])[:3])
    return c


def create_film_film_type(type_in2, film_in):
    c = []
    for i, row in enumerate(film_in):
        for j, my_type in enumerate(type_in2):
            if str(my_type[2]).lower() in str(row[2]).lower():
                tup = (i + 1, j + 1)
                c.append(tup)
    return c


def create_film_prod_country(country_in, film_in):
    d, st1 = [], []
    for i, row in enumerate(film_in):
        st1 = row[5].split(", ")
        for my_st1 in st1:
            for j, my_cou in enumerate(country_in):
                tup = ()
                if str(my_cou[1]).lower() == str(my_st1).lower() or str(my_cou[3]).lower() == str(my_st1).lower():
                    tup = (i + 1, my_cou[0])
                    d.append(tup)
                    break
                elif str(my_st1).lower() == 'nszk':
                    tup = (i + 1, 'DE')
                    d.append(tup)
                    break
    return d


def create_film_director(column, film_in):
    e = []
    for i, row in enumerate(film_in):
        my_string = str(row[column])
        if len(my_string) > 0 and my_string.lower() != 'ismeretlen' and my_string.lower()[:4] != 'több' \
                and my_string.lower()[:4] != 'ninc':
            tup = ()
            st1 = row[column].split(", ")
            for my_st1 in st1:
                tup = (i + 1, my_st1)
                e.append(tup)
    return e


def modify_film_film_rate(film_rate_in, film_in):
    c, d = [], []
    for i, row in enumerate(film_in):
        c = list(row)
        c.pop(2)
        del c[4:7]
        st1 = str(c[4])
        c[4] = 1
        if len(st1) > 1:
            for j, my_rate in enumerate(film_rate_in):
                if str(my_rate[2]).upper() == st1.upper():
                    c[4] = j + 1
                    break
        c.append(1)  # FilmPriceType default
        tup = tuple(c)
        d.append(tup)
    return d


if __name__ == "__main__":
    film_data = open_csv_file(r'D:\\Python\\filmadatbazis_jo.csv', "iso-8859-2", "tup")
    write_sql_data(film_data, film_orig)
    film_dict = open_csv_file(r'D:\\Python\\FilmTipus.csv', "iso-8859-2", "list")
    # film_dict = create_film_type(film_dict)
    write_sql_data(film_dict, film_type)
    film_dict = create_film_film_type(film_dict, film_data)
    write_sql_data(film_dict, film_film_type)
    film_country = open_csv_file(r'D:\\Python\\Orszagkodok.csv', "iso-8859-2", "list")
    film_cou = create_film_prod_country(film_country, film_data)
    write_sql_data(film_cou, film_film_cou)
    film_rate = open_csv_file(r'D:\\Python\\FilmRating.csv', "iso-8859-2", "list")
    write_sql_data(film_rate, film_film_rate)
    film_director = create_film_director(6, film_data)  # 6=director
    write_sql_data(film_director, film_film_director)
    film_director = create_film_director(7, film_data)  # 7=star
    write_sql_data(film_director, film_film_star)
    film_rat2 = modify_film_film_rate(film_rate, film_data)
    write_sql_data(film_rat2, film_normal)
