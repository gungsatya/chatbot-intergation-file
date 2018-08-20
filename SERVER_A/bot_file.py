import mysql.connector as mc
import requests
import telebot

TOKEN = '278255485:AAEqoXfE1Dwv79FBxhdAMKy7BSfA9SoqlTE'
bot = telebot.TeleBot(TOKEN)
database = {"host": "localhost", "user": "root", "password": "", "db": "telegram_msg"}


def isExist(update_id):
    conn = mc.MySQLConnection(**database)
    c = conn.cursor()
    query = '''SELECT * FROM `in` WHERE `update_id`='%s' ''' % update_id
    c.execute(query)
    count = 0
    for row in c.fetchall(): count += 1
    if (count > 0):
        return True
    else:
        return False


def sendFileMsg(chat_id, fname):
    doc = open(fname, 'rb')
    send = bot.send_document(chat_id, doc)
    print(send)


def sendMsg(chat_id, msg):
    send = bot.send_message(chat_id, msg)
    print(send)


def replyMsg():
    conn = mc.MySQLConnection(**database)
    c = conn.cursor()
    query = '''SELECT * FROM `out` WHERE sttus ='ready' '''
    c.execute(query)
    for row in c.fetchall():
        sendMsg(row[1], row[2])
        query = '''UPDATE `out` SET sttus='sent' WHERE id = %i''' % row[0]
        c.execute(query)
        conn.commit()


def downloadFile():
    conn = mc.MySQLConnection(**database)
    c = conn.cursor()
    query = "SELECT * FROM `in` WHERE `attachment`='true' AND `downloaded`='false'"
    c.execute(query)
    for row in c.fetchall():
        file_info = bot.get_file(row[5])
        r = requests.get('https://api.telegram.org/file/bot{0}/{1}'.format(TOKEN, file_info.file_path))
        with open('download/' + row[6], 'wb') as f:
            for chunk in r.iter_content(chunk_size=1024):
                if chunk:
                    f.write(chunk)
        query = '''UPDATE `in` SET `downloaded`='true' WHERE id = %i''' % row[0]
        c.execute(query)
        conn.commit()


def receiveMsg():
    conn = mc.MySQLConnection(**database)
    c = conn.cursor()

    msgs = bot.get_updates()
    for msg in msgs:
        chat_text = ""
        file_id = ""
        file_name = ""
        mime_type = ""
        channel_post = msg.channel_post
        if (channel_post != None):
            update_id = msg.update_id
            doc = channel_post.document
            chat_id = channel_post.chat.id
            if (doc == None):
                attachment = 'false'
                chat_text = channel_post.text
            else:
                attachment = 'true'
                file_id = doc.file_id
                file_name = doc.file_name
                mime_type = doc.mime_type

            if (not isExist(update_id)):
                query = '''INSERT INTO `in`(
                    update_id, chat_id, chat_text,
                    attachment, file_id, file_name,
                    mime_type) VALUES (%i,%i,'%s','%s','%s','%s','%s')
                ''' % (
                    update_id, chat_id, chat_text,
                    attachment, file_id, file_name,
                    mime_type)
                c.execute(query)
                conn.commit()
