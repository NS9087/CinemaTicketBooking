from somefunctions import open_csv_file, write_sql_data
from datetime import datetime, timedelta

screen_june = [(1, 9920, 115), (2, 11954, 145), (3, 9722, 114), (4, 9722, 114), (5, 11864, 141)]
screen_july = [(1, 1078, 80), (2, 6127, 99), (3, 3943, 92), (4, 8526, 108), (5, 1180, 81)]
screen_august = [(1, 12589, 99), (2, 12583, 174), (3, 12608, 102), (4, 12583, 174), (5, 6392, 100)]
film_screen = '''INSERT INTO CinemaTicketBooking.dbo.Screening (FilmID, AuditoriumID, ScreeningStart) 
                    VALUES (?,?,?)'''

film_seat = '''INSERT INTO CinemaTicketBooking.dbo.Seat (AuditoriumID, SeatNumber, RowNumber) 
                    VALUES (?,?,?)'''


def create_screening_data(scree_in, my_month, my_day, my_hour):
    c, d = [], []
    for k in range(my_day):
        my_numb = 5
        a = datetime(2021, my_month, k + 1, my_hour)
        if a.weekday() <= 4:
            a = datetime(2021, my_month, k + 1, my_hour + 3)
            my_numb = 4
        for j in range(my_numb):
            for i, row in enumerate(scree_in):
                add_min = int((row[2] + 45) / 30) * 30 * j
                my_time = a + timedelta(minutes=add_min)
                if my_time.hour > 22:
                    continue
                c.append(row[1])
                c.append(row[0])
                c.append(str(my_time))
                tup = tuple(c)
                d.append(tup)
                c = []
    return d


def create_seat_table(numb_terem):
    c, d = [], []
    for i in range(numb_terem):
        my_row = 5
        if i < 3:
            my_row = 10
        for j in range(my_row):
            for k in range(10):
                c.append(i + 1)
                c.append(k + 1)
                c.append(j + 1)
                tup = tuple(c)
                d.append(tup)
                c = []
    return d


if __name__ == "__main__":
    # screen_data = create_screening_data(screen_june, 6, 30, 11)
    # write_sql_data(screen_data, film_screen)
    # screen_data = create_screening_data(screen_july, 7, 31, 11)
    # write_sql_data(screen_data, film_screen)
    # seat_data = create_seat_table(5)
    # write_sql_data(seat_data, film_seat)
    screen_data = create_screening_data(screen_august, 8, 31, 11)
    # write_sql_data(screen_data, film_screen)
    print(screen_data)


