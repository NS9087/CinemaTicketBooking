import random
from random import randrange
from datetime import timedelta, datetime
from somefunctions import write_sql_data, open_csv_file

film_reserv = '''INSERT INTO CinemaTicketBooking.dbo.Reservation (ScreeningID, ContactReserveID, ReservationTypeID, 
                    ContactPaidID, Reserved, Paid, Active, ReservationDate, ConfirmationDate, ReservationContact, 
                    ContactEmail, ReservationRefNo) 
                    VALUES (?,?,?,?,?,?,?,?,?,?,?,?)'''

reservation_elem = [(1, 290, 5, 16, 30), (291, 580, 6, 1, 15), (581, 900, 6, 16, 30), (901, 1245, 7, 1, 15)]


def random_date(start, end):
    delta = end - start
    int_delta = (delta.days * 24 * 60 * 60) + delta.seconds
    random_second = randrange(int_delta)
    return start + timedelta(seconds=random_second)


def gen_random_datetime(my_month, my_day):
    d1 = datetime(2021, my_month, my_day, 6)
    d2 = datetime(2021, my_month, my_day, 23)
    return random_date(d1, d2)


def create_reservation_data(my_numb, reservation_part, res_type, contact_start, contact_end):
    c, d = [], []
    for j, elem in enumerate(reservation_part):
        for i in range(my_numb):
            for k in range(elem[0], elem[1] + 1):
                c.append(k)
                c.append(random.randrange(contact_start, contact_end + 1))  # ContactReserveID 367
                c.append(res_type)
                c.append(None)
                c.append('1')  # Reserved
                c.append('0')  # Paid
                c.append('1')  # Active
                my_random_date = gen_random_datetime(elem[2], random.randrange(elem[3], elem[4]))
                c.append(str(my_random_date))
                c.append(str(my_random_date + timedelta(minutes=random.randrange(20, 55))))
                c.append(None)
                c.append(None)
                c.append(random.randrange(10001222, 99222999))  # ReservationRefNo
                tup = tuple(c)
                d.append(tup)
                c = []
    return d


def convert_data(orig_data, res_type):
    c, d = [], []
    for j, elem in enumerate(orig_data):
        c.append(int(elem[0]))
        c.append(None)
        c.append(res_type)  # orig 3
        c.append(None)
        c.append(elem[4])
        c.append(elem[5])
        c.append(elem[6])
        if res_type == 3:
            c.append(str(datetime.strptime(elem[7], '%Y.%m.%d %H:%M%S')))
            c.append(str(datetime.strptime(elem[8], '%Y.%m.%d %H:%M%S')))
            c.append(elem[9])
            c.append(elem[10])
            c.append(int(elem[11]))
        else:
            c.append(datetime.now())
            c.append(None)
            c.append(None)
            c.append(None)
            c.append(None)
        tup = tuple(c)
        d.append(tup)
        c = []
    return d


if __name__ == "__main__":
    my_data = create_reservation_data(4, reservation_elem, 2, 2, 367)
    write_sql_data(my_data, film_reserv)
    my_data = create_reservation_data(1, reservation_elem, 4, 368, 415)
    write_sql_data(my_data, film_reserv)
    read_data = open_csv_file(r'D:\\Python\\Reservation.csv', 'iso-8859-2', 'tup')
    r1_data = convert_data(read_data, 3)
    write_sql_data(r1_data, film_reserv)
    r1_data = convert_data(read_data, 1)
    write_sql_data(r1_data, film_reserv)

