import random
import csv
import unicodedata
import pyodbc

# from someFunctions import additional_address_part

act_param = [r'D:\\Python\\CinemaTicketImpFiles\\Person_Adr.csv', r'D:\\Python\\CinemaTicketImpFiles\\Company_Adr.csv',
             "iso-8859-2", "test1.txt", 500, 50, 14, 22, 26]
pub_place = ("út", "út", "út", "út", "út", "utca", "utca", "utca", "u.", "u.", "tér", "köz", "fasor")
domain_name = ("@t-online.hu", "@gmail.com", "@freeonline.hu", "@telenor.hu")
company_type = ("Kft.", "Kft.", "Kft.", "Kft.", "Zrt.", "Bt.", "Kkt.", "Bt.", "Nonprofit Kft.")
mobile_prefix = ("06-20-", "06-30-", "06-70-")
company_mail_prefix = ("info@", "iroda@", "ceg@")
company_mail_post = (".hu", ".com", ".eu")
header_param = ("ContactName", "CountryCode", "ZIP", "City", "Address", "ZIPShip", "CityShip",
                "AddressShip", "ZIPPostal", "CityPostal", "AddressPostal", "IsCustomer", "IsSupplier",
                "IsEmployee", "IsLogin", "Phone", "Mobile", "Email", "VATNr", "PaymentTypeID")
cash_customer = ('Kp. vevő - pénztárban', None, None, None, None, '1', '1', '0', '0','0', None,
                 None, None, 'HU', None, None, None, None, None, None, None)


def additional_address_part(line_num, numb, before_street, from_tup, to_tuple):
    if line_num % numb != 0:
        to_tuple.append(None)
        to_tuple.append(None)
        to_tuple.append(None)
    else:
        to_tuple.append(from_tup[4])
        to_tuple.append(from_tup[5])
        to_tuple.append(before_street + " " + str(random.randrange(9, 132)))
    return to_tuple


def get_hun_tax8(orig7):
    a = str(orig7)
    b = (9, 7, 3, 1, 9, 7, 3)
    sum1 = 0
    for elem, j in zip(a, b):
        sum1 += j * int(elem)
    return a + str(10 - int(str(sum1)[-1]))[-1]


def get_hun_phone(zip_part):
    s1 = str(zip_part)
    if s1[0] == "1":
        return "06-1-" + str(random.randrange(1452346, 9898656))
    else:
        return "06-" + str(int(s1[0]) * 10 + 2) + "-" + str(random.randrange(145234, 989865))


def add_more_random_data(my_type, orig_data):
    t1 = 0
    before_adr = ""
    c3 = []
    ship_num = act_param[6]
    post_num = act_param[7]
    for elem in orig_data:  # first split tuples then put together in a list
        c, c2 = [], []
        x1 = ""
        t1 += 1
        for j in elem:
            x1 = x1 + " " + (str(j))
        c = x1.split(" ")
        c2.append(c[4])
        c2.append(c[5])
        if my_type == 0:
            c2.insert(0, c[1] + " " + c[2])
            c2.insert(3, c[3] + " " + random.choice(pub_place) + " " + str(random.randrange(4, 192)) + ".")
        elif my_type == 1:
            c2.insert(0, c[1] + c[2] + " " + random.choice(company_type))
            c2.insert(3, c[3] + " " + random.choice(pub_place) + " " + str(random.randrange(11, 252)) + ".")
        else:
            c2.insert(0, None)  # ?
            c2.insert(3, None)
            c2.append(None)
        st1 = unicodedata.normalize("NFD", c[1].lower()).encode("ascii", "ignore").decode("utf8")
        st2 = unicodedata.normalize("NFD", c[2].lower()).encode("ascii", "ignore").decode("utf8")
        if my_type > 0:
            c2.append(random.choice(company_mail_prefix) + st1 + st2 + random.choice(company_mail_post))
            c2.append(random.randrange(2, 4))  # PaymentTypeID Company
        else:
            st1 = st1 + "." + st2 + str(random.randrange(1, 99))
            c2.append(st1 + random.choice(domain_name))
            c2.append(random.randrange(1, 3))  # PaymentTypeID PrivatePerson
        c2.append("1")  # IsCustomer
        c2.append("0")
        if t1 % act_param[8] == 0 and my_type < 1:
            c2.append("1")
            c2.append("1")
        else:
            c2.append("0")
            c2.append("0")
        if my_type > 0:
            c2.append(get_hun_tax8(random.randrange(1212123, 8989899)) + c[6])
            c2.append(None)  # Mobile
            c2.append(get_hun_phone(c[4]))  # Phone
        else:
            c2.append(None)  # VATNr
            c2.append(random.choice(mobile_prefix) + str(random.randrange(1216743, 9898982)))  # Mobile
            c2.append(None)  # Phone
        c2.append("HU")     #CountryCode
        if my_type == 0:
            additional_address_part(t1, 1000, before_adr, c, c2)
        else:
            additional_address_part(t1, ship_num, before_adr, c, c2)
        additional_address_part(t1, post_num, before_adr, c, c2)
        before_adr = c[3] + " " + random.choice(pub_place)
        c2.append(None)  #CloseDate
        tuc = tuple(c2)
        c3.append(tuc)
    if my_type == 0:
         c3.insert(0, tuple(cash_customer))
    return c3


def print_data_text(my_type, print_list):
    txt_file_name = act_param[3]
    print_type = "w"
    if my_type > 0:
        print_type = "a"
    f = open(txt_file_name, print_type, encoding=act_param[2])
    for elem in print_list:
        for j in elem:
            f.writelines(str(j) + "\t")
        f.writelines("\n")
    f.close()


def check_first2_same(small_list, large_list):
    my_found = 0
    for element in large_list:
        if element[0] == small_list[0] and element[1] == small_list[1]:
            my_found = 1
            break
    return my_found


def create_random_names(my_type, line_name):
    c, c1 = [], []
    num_line = act_param[4 + my_type]
    k1 = num_line
    for elem in range(0, num_line):
        for element in line_name:
            c.append(random.choice(element))
        if check_first2_same(c, c1) == 0 or elem < 2:
            tuc = tuple(c)
            c1.append(tuc)
        else:
            num_line += 1
        if elem >= k1 <= len(c1):
            num_line += 1
        c = []
    return c1  # random chosen names and addresses in tuple and in a list


def connect_sql_server(contact_data_sql):
    conn = pyodbc.connect('Driver={ODBC Driver 17 for SQL Server};'
                          'Server=.;'
                          'Database=CinemaTicketBooking;'
                          'Trusted_Connection=yes;')
    cursor = conn.cursor()
    for element, row in enumerate(contact_data_sql):
        cursor.execute('''INSERT INTO CinemaTicketBooking.dbo.Contact (ContactName, ZIP, City, Address,
                    Email, PaymentTypeID, IsCustomer, IsSupplier, IsEmployee, IsLogin, VATNr, Mobile, Phone, 
                    CountryCode, ZIPShip, CityShip, AddressShip, ZIPPostal, CityPostal, AddressPostal, CloseDate) 
                    VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)'''
                       , row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9],
                       row[10], row[11], row[12], row[13], row[14], row[15], row[16], row[17], row[18],
                       row[19], row[20])
        conn.commit()


def open_csv_file(my_type):
    with open(act_param[my_type], newline="", encoding=act_param[2]) as f:
        reader = csv.reader(f, delimiter=";")
        data = [tuple(row) for row in reader]
        #  data = list(reader)
    return data


if __name__ == "__main__":
    for i in range(2):
        read_data = open_csv_file(i)
        random_data = create_random_names(i, read_data)
        # print(random_data)
        # print(len(random_data))
        random_data2 = add_more_random_data(i, random_data)
        print(random_data2)
        print(len(random_data2))
        # connect_sql_server(random_data2)

        # random_data2 = add_more_random_data(i, act_param[4], random_data)
        # print_data_text(i, random_data2)

#  tuc = tuple(contact_data)
