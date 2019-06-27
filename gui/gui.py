import subprocess
import random
import sys
from PyQt5.QtWidgets import (QApplication, QCheckBox, QGridLayout, QGroupBox,
        QMenu, QPushButton, QRadioButton, QVBoxLayout, QWidget, QLineEdit, QLabel)
from PyQt5.QtGui import QIcon, QPalette
from PyQt5.QtCore import pyqtSlot, Qt
from PyQt5.QtGui import QIcon, QPixmap, QIntValidator

import pandas as pd

class App(QWidget):

    def __init__(self):
        super().__init__()
        self.title = 'Monitoring Tool'
        self.left = 10
        self.top = 10
        self.width = 540
        self.height = 800
        self.immagine_accellerometri = "schema_accellerometri.png"
        self.df = pd.read_csv("../data/test_dataset.csv", sep = ';')
        self.res = 0
        self.total = 0
        self.right = 0

        self.initUI()
    
    def initUI(self):
        grid = QGridLayout()
        grid.addWidget(self.createSensor_first(), 0, 0)
        grid.addWidget(self.createSensor_second(), 1, 0)
        grid.addWidget(self.createSensor_third(), 2, 0)
        grid.addWidget(self.createSensor_fourth(), 3, 0)

        grid.addWidget(self.create_image_sensor(), 0, 1)
        grid.addWidget(self.create_activity(), 1, 1)
        grid.addWidget(self.add_button(), 2, 1)
        grid.addWidget(self.result(), 3, 1)

        self.setLayout(grid)

        self.setWindowTitle(self.title)
        self.setGeometry(self.left, self.top, self.width, self.height)

        #self.saveFileDialog()
        self.show()

    def result(self):
        groupBox = QGroupBox("")
        
        match_text = QLabel(self)
        match_text.setText('Match:')
        self.match = QLineEdit(self, placeholderText="")
        self.match.setReadOnly(True)
        
        perc_match_text = QLabel(self)
        perc_match_text.setText('Match Percentage:')
        self.perc_match = QLineEdit(self, placeholderText="")
        self.perc_match.setReadOnly(True)

        vbox = QVBoxLayout()
        vbox.addWidget(match_text)
        vbox.addWidget(self.match)
        vbox.addWidget(perc_match_text)
        vbox.addWidget(self.perc_match)

        vbox.addStretch(1)
        groupBox.setLayout(vbox)
    
        return groupBox


    def add_button(self):
        groupBox = QGroupBox("")

        self.button_run = QPushButton('Run', self)
        self.button_run.setToolTip('Run')
        self.button_run.clicked.connect(self.on_click_run)

        self.button_reset = QPushButton('Reset', self)
        self.button_reset.setToolTip('Reset')
        self.button_reset.clicked.connect(self.on_click_reset)

        activity_select_text = QLabel(self)
        activity_select_text.setText('Activity select:')
        self.activity_select = QLineEdit(self, placeholderText="")
        self.activity_select.setReadOnly(True)

        activity_predict_text = QLabel(self)
        activity_predict_text.setText('Activity predict:')
        self.activity_predict = QLineEdit(self, placeholderText="")
        self.activity_predict.setReadOnly(True)    

        vbox = QVBoxLayout()
        vbox.addWidget(self.button_run)
        vbox.addWidget(self.button_reset)
        vbox.addWidget(activity_select_text)
        vbox.addWidget(self.activity_select)
        vbox.addWidget(activity_predict_text)
        vbox.addWidget(self.activity_predict)

        vbox.addStretch(1)
        groupBox.setLayout(vbox)

        return groupBox

    @pyqtSlot()
    def on_click_reset(self):
        print("reset")
        self.right = 0
        self.total = 0

        self.roll1.setText('')
        self.pitch1.setText('')
        self.accel1.setText('')

        self.roll2.setText('')
        self.pitch2.setText('')
        self.accel2.setText('')

        self.roll3.setText('')
        self.pitch3.setText('')
        self.accel3.setText('')

        self.roll4.setText('')
        self.pitch4.setText('')
        self.accel4.setText('')

        self.activity_select.setText('')
        self.activity_predict.setText('')

        self.match.setText('')
        self.perc_match.setText('')

    @pyqtSlot()
    def on_click_run(self):
        print("run")

        # prendiamo il attività selezionata
        if self.sitting.isChecked():
            self.activity_select.setText("sitting")
        elif self.sittingdown.isChecked():
            self.activity_select.setText("sittingdown")
        elif self.standing.isChecked():
            self.activity_select.setText("standing")
        elif self.standingup.isChecked():
            self.activity_select.setText("standingup")
        elif self.walking.isChecked():
            self.activity_select.setText("walking")
        elif self.random.isChecked():
            self.activity_select.setText(random.choice(["sitting", "sittingdown", "standing", "standingup", "walking"]))

        class_df = self.df.loc[self.df['class'] == self.activity_select.text()]

        row_df = pd.DataFrame()
        row_df = row_df.append(class_df.sample(n = 1))
        
        self.roll1.setText(str(row_df['roll1_disc'].iloc[0]))
        self.pitch1.setText(str(row_df['pitch1_disc'].iloc[0]))
        self.accel1.setText(str(row_df['accel1_disc'].iloc[0]))

        self.roll2.setText(str(row_df['roll2_disc'].iloc[0]))
        self.pitch2.setText(str(row_df['pitch2_disc'].iloc[0]))
        self.accel2.setText(str(row_df['accel2_disc'].iloc[0]))

        self.roll3.setText(str(row_df['roll3_disc'].iloc[0]))
        self.pitch3.setText(str(row_df['pitch3_disc'].iloc[0]))
        self.accel3.setText(str(row_df['accel3_disc'].iloc[0]))

        self.roll4.setText(str(row_df['roll4_disc'].iloc[0]))
        self.pitch4.setText(str(row_df['pitch4_disc'].iloc[0]))
        self.accel4.setText(str(row_df['accel4_disc'].iloc[0]))


        row_df.to_csv('query_row.csv', sep = ';', index = False)

        subprocess.call('Rscript --vanilla ../Bayesian/script_for_gui.r  query_row.csv result.csv',  shell=True)
        
        result_pd = pd.read_csv("result.csv", sep = ';')
        self.res = result_pd['query'].iloc[0]
        self.activity_predict.setText(str(result_pd['prob_max_class'].iloc[0]))

        self.total = self.total + 1
        if (self.res == 1):
            self.right = self.right + 1
        
        self.match.setText(str(self.right) + '/' + str(self.total))
        self.perc_match.setText(str(self.right / self.total * 100))

    def create_image_sensor(self):
        groupBox = QGroupBox("Sensor disposition")
        
        immage_original = QLabel(self)
        pixmap = QPixmap(self.immagine_accellerometri)
        pixmap_resized = pixmap.scaled(200, 500, Qt.KeepAspectRatio)
        
        immage_original.setPixmap(pixmap_resized)
        #immage_original.setScaledContents(True)
        vbox = QVBoxLayout()
        vbox.addWidget(immage_original)

        vbox.addStretch(1)
        groupBox.setLayout(vbox)

        return groupBox

    def create_activity(self):
        groupBox = QGroupBox("Activity")
        
        activity_text = QLabel(self)
        activity_text.setText('Select Activity:')
        #activity = QLineEdit(self, placeholderText="")
        
        #"sitting","sittingdown","walking","standing","standingup"

        self.random = QRadioButton("Random")
        self.random.setChecked(True)
        self.sitting = QRadioButton("Sitting")
        self.sittingdown = QRadioButton("Sittingdown")
        self.standing = QRadioButton("Standing")
        self.standingup = QRadioButton("Standingup")
        self.walking = QRadioButton("Walking")

        vbox = QVBoxLayout()
        vbox.addWidget(activity_text)
        vbox.addWidget(self.random)
        vbox.addWidget(self.sitting)
        vbox.addWidget(self.sittingdown)
        vbox.addWidget(self.standing)
        vbox.addWidget(self.standingup)
        vbox.addWidget(self.walking)

        vbox.addStretch(1)
        groupBox.setLayout(vbox)

        return groupBox
        
    def createSensor_first(self):
            groupBox = QGroupBox("First Sensor Waist")
            
            roll1_text = QLabel(self)
            roll1_text.setText('Roll:')
            self.roll1 = QLineEdit(self, placeholderText="")
            self.roll1.setReadOnly(True)
            pitch1_text = QLabel(self)
            pitch1_text.setText('Pitch:')
            self.pitch1 = QLineEdit(self, placeholderText="")
            self.pitch1.setReadOnly(True)
            accel1_text = QLabel(self)
            accel1_text.setText('Acceleration:')
            self.accel1 = QLineEdit(self, placeholderText="")
            self.accel1.setReadOnly(True)

            vbox = QVBoxLayout()
            vbox.addWidget(roll1_text)
            vbox.addWidget(self.roll1)
            vbox.addWidget(pitch1_text)
            vbox.addWidget(self.pitch1)
            vbox.addWidget(accel1_text)
            vbox.addWidget(self.accel1)

            vbox.addStretch(1)
            groupBox.setLayout(vbox)

            return groupBox

    def createSensor_second(self):
            groupBox = QGroupBox("Second Sensor Left Things")

            roll2_text = QLabel(self)
            roll2_text.setText('Roll:')
            self.roll2 = QLineEdit(self, placeholderText="")
            self.roll2.setReadOnly(True)
            pitch2_text = QLabel(self)
            pitch2_text.setText('Pitch:')
            self.pitch2 = QLineEdit(self, placeholderText="")
            self.pitch2.setReadOnly(True)
            accel2_text = QLabel(self)
            accel2_text.setText('Acceleration:')
            self.accel2 = QLineEdit(self, placeholderText="")
            self.accel2.setReadOnly(True)

            vbox = QVBoxLayout()
            vbox.addWidget(roll2_text)
            vbox.addWidget(self.roll2)
            vbox.addWidget(pitch2_text)
            vbox.addWidget(self.pitch2)
            vbox.addWidget(accel2_text)
            vbox.addWidget(self.accel2)

            vbox.addStretch(1)
            groupBox.setLayout(vbox)

            return groupBox
        
    def createSensor_third(self):
            groupBox = QGroupBox("Third Sensor Right Arm")
            
            roll3_text = QLabel(self)
            roll3_text.setText('Roll:')
            self.roll3 = QLineEdit(self, placeholderText="")
            self.roll3.setReadOnly(True)
            pitch3_text = QLabel(self)
            pitch3_text.setText('Pitch:')
            self.pitch3 = QLineEdit(self, placeholderText="")
            self.pitch3.setReadOnly(True)
            accel3_text = QLabel(self)
            accel3_text.setText('Acceleration:')
            self.accel3 = QLineEdit(self, placeholderText="")
            self.accel3.setReadOnly(True)

            vbox = QVBoxLayout()
            vbox.addWidget(roll3_text)
            vbox.addWidget(self.roll3)
            vbox.addWidget(pitch3_text)
            vbox.addWidget(self.pitch3)
            vbox.addWidget(accel3_text)
            vbox.addWidget(self.accel3)

            vbox.addStretch(1)
            groupBox.setLayout(vbox)

            return groupBox

    def createSensor_fourth(self):
            groupBox = QGroupBox("Fourth Sensor Right Ankle")
            
            roll4_text = QLabel(self)
            roll4_text.setText('Roll:')
            self.roll4 = QLineEdit(self, placeholderText="")
            self.roll4.setReadOnly(True)
            pitch4_text = QLabel(self)
            pitch4_text.setText('Pitch:')
            self.pitch4 = QLineEdit(self, placeholderText="")
            self.pitch4.setReadOnly(True)
            accel4_text = QLabel(self)
            accel4_text.setText('Acceleration:')
            self.accel4 = QLineEdit(self, placeholderText="")
            self.accel4.setReadOnly(True)

            vbox = QVBoxLayout()
            vbox.addWidget(roll4_text)
            vbox.addWidget(self.roll4)
            vbox.addWidget(pitch4_text)
            vbox.addWidget(self.pitch4)
            vbox.addWidget(accel4_text)
            vbox.addWidget(self.accel4)

            vbox.addStretch(1)
            groupBox.setLayout(vbox)

            return groupBox

if __name__ == '__main__':
    app = QApplication(sys.argv)
    #app.setStyle('Fusion')
    palette = QPalette()
    palette.setColor(QPalette.Base, Qt.gray)
    #palette.setColor(QPalette.Text, Qt.darkGray)
    app.setPalette(palette)
    ex = App()
    sys.exit(app.exec_())