import random
import csv
import pyodbc

conn_string = 'Driver={ODBC Driver 17 for SQL Server}; Server=.; Database=CinemaTicketBooking; Trusted_Connection=yes;'


def additional_address_part(numb, before_street, from_tup, to_tuple) -> object:
    if numb != 0:
        to_tuple.append(' ')
        to_tuple.append(' ')
        to_tuple.append(' ')
    else:
        to_tuple.append(from_tup[3])
        to_tuple.append(from_tup[4])
        to_tuple.append(before_street + ' ' + str(random.randrange(9, 132)))
    return to_tuple


def open_csv_file(my_file, my_encode, my_type):
    with open(my_file, newline="", encoding=my_encode) as f:
        reader = csv.reader(f, delimiter=";")
        if my_type == 'list':
            data = list(reader)
        elif my_type == 'tup':
            data = [tuple(row) for row in reader]
    return data


def write_sql_data(write_data,sql_my_command):
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()
    for i, row in enumerate(write_data):
        cursor.execute(sql_my_command, row)
        conn.commit()

# def check_first2_same(small_list, large_list):
#     my_found = 0
#     for element in large_list:
#         if element[0] == small_list[0]: # and element[1] == small_list[1]:
#             my_found = 1
#             break
#     return my_found
#
#
# c, c1 = [], []
# c2 = (2, 4, 5, 7, 1, 9)
# k, k1 = 5, 5
# for elem in range(0, k):
#     for element in c2:
#         c.append(random.choice(c2))
#     if check_first2_same(c, c1) == 0 or elem < 2:
#         tuc = tuple(c)
#         c1.append(tuc)
#     else:
#         k += 1
#     if elem > k1 >= len(c1):
#         k += 1
#     print(elem, c1, k)
#   #  print(elem, c, k)
#     c = []
# print(googletrans.LANGUAGES)

# translator = Translator()
# result = translator.translate('Nem fikciós művek', src='hu', dest='en')
#
# print(result.text)

# def write_sql_film_my(write_data):
#     conn = pyodbc.connect(conn_string)
#     cursor = conn.cursor()
#     for i, row in enumerate(write_data):
#         if i > 0:
#             cursor.execute('''INSERT INTO CinemaTicketBooking.dbo.FilmMy (TitleHU, TitleOrig, FilmCategory, ReleaseYear,
#                         DurationMin, ProdCountry, Director, Stars, FilmRatingType) VALUES (?,?,?,?,?,?,?,?,?)'''
#                            , row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8])
#         conn.commit()


