import random
from somefunctions import open_csv_file, write_sql_data
from datetime import datetime, timedelta

seat_num = (100, 100, 100, 50, 50)

res_seat = '''INSERT INTO CinemaTicketBooking.dbo.SeatReserved (ReservationID, ScreeningID, SeatID, ViewerTypeID) 
                    VALUES (?,?,?,?)'''

tick_sale = '''INSERT INTO CinemaTicketBooking.dbo.TicketSale (ReservationID, PriceID, TicketQty, TicketPrice,
                      SoldTotal, PaymentDate, PaymentTypeID)   VALUES (?,?,?,?,?,?,?)'''


def find_seat_stop_start(audit_nr):
    seat_top_start = 0
    for m, snum in enumerate(seat_num):
        if m < audit_nr:
            seat_top_start += snum
        else:
            break
    return seat_top_start


def add_seat_data(orig_data, seat_data):
    c, d = [], []
    prev_screen = 0
    for i, elem in enumerate(orig_data):
        seat_per_res = random.randrange(1, 8)
        if int(elem[1]) > 3:
            seat_per_res = random.randrange(1, 4)
        if elem[0] != prev_screen:
            seat_top_start = find_seat_stop_start(int(elem[1]))
        for j in range(seat_per_res):
            seat_top_start -= 1
            c.append(elem[2])
            c.append(elem[0])
            c.append(seat_top_start)
            viewtype = 1
            if seat_top_start % 4 == 0:
                viewtype = random.randrange(2, 4)
            c.append(viewtype)
            c.append(elem[3])
            tup = tuple(c)
            d.append(tup)
            c = []
            prev_screen = elem[0]
        if seat_top_start %2 == 0:
            seat_top_start -= 1
    return d


def gen_seat_data(orig_data):
    c, d = [], []
    for i, elem in enumerate(orig_data):
        for j, element in enumerate(elem):
            if j > 3:
                continue
            c.append(element)
        tup = tuple(c)
        d.append(tup)
        c = []
    return d


def ticket_sub(reserv_num, price_id, qty, date_part):
    d = []
    d.append(reserv_num)
    d.append(price_id)
    d.append(qty)
    d.append(None)
    d.append(None)
    d.append(date_part)
    d.append(random.randrange(1,5))
    return d


def gen_ticket_sale(orig_data):
    c, d = [], []
    prev_reserv = 0
    x1, x2, x3 = 0, 0, 0
    t1, t2, t3 = 1, 2, 3
    for i, elem in enumerate(orig_data):
        if prev_reserv != elem[0] and i > 0:
            if x1 > 0:
                c = ticket_sub(prev_reserv, t1, x1, st)
                tup = tuple(c)
                d.append(tup)
            if x2 > 0:
                c = ticket_sub(prev_reserv, t2, x2, st)
                tup = tuple(c)
                d.append(tup)
            if x3 > 0:
                c = ticket_sub(prev_reserv, t3, x3, st)
                tup = tuple(c)
                d.append(tup)
            x1, x2, x3 = 0, 0, 0
        if elem[3] == t1:
            x1 += 1
        elif elem[3] == t2:
            x2 += 1
        elif elem[3] == t3:
            x3 += 1
        else:
            print('hupsz')
        prev_reserv = elem[0]
        st = str(datetime.strptime(elem[4], '%Y.%m.%d %H:%M') + timedelta(seconds=random.randrange(-5000, -300)))
    return d


if __name__ == "__main__":
    read_data = open_csv_file(r'D:\\Python\\Screen_Aud_Res_Sdate.csv', "iso-8859-2", "tup")
    mod_data = add_seat_data(read_data, seat_num)
    print(len(mod_data))
    seat_data = gen_seat_data(mod_data)
    write_sql_data(seat_data, res_seat)
    ticket_sal_data = gen_ticket_sale(mod_data)
    print(len(ticket_sal_data))
    write_sql_data(ticket_sal_data, tick_sale)


