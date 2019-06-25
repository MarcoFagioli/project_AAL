import sys
from PyQt5.QtWidgets import (QApplication, QCheckBox, QGridLayout, QGroupBox,
        QMenu, QPushButton, QRadioButton, QVBoxLayout, QWidget, QLineEdit, QLabel)
from PyQt5.QtGui import QIcon, QPalette
from PyQt5.QtCore import pyqtSlot, Qt
from PyQt5.QtGui import QIcon, QPixmap, QIntValidator

class App(QWidget):

    def __init__(self):
        super().__init__()
        self.title = 'Monitoring Tool'
        self.left = 10
        self.top = 10
        self.width = 540
        self.height = 740
        self.immagine_accellerometri = "schema_accellerometri.png"
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
        
        
        #vbox.addStretch(1)
        #groupBox.setLayout(vbox)
    
        return groupBox


    def add_button(self):
        groupBox = QGroupBox("")

        self.button_reset = QPushButton('Reset', self)
        self.button_reset.setToolTip('Reset')
        self.button_reset.clicked.connect(self.on_click_reset)

        self.button_run = QPushButton('Run', self)
        self.button_run.setToolTip('Run')
        self.button_run.clicked.connect(self.on_click_run)

        activity_select_text = QLabel(self)
        activity_select_text.setText('Activity select:')
        self.activity_select = QLineEdit(self, placeholderText="")
        self.activity_select.setReadOnly(True)

        activity_label_text = QLabel(self)
        activity_label_text.setText('Activity label:')
        self.activity_label = QLineEdit(self, placeholderText="")
        self.activity_label.setReadOnly(True)    

        vbox = QVBoxLayout()
        vbox.addWidget(self.button_reset)
        vbox.addWidget(self.button_run)
        vbox.addWidget(activity_select_text)
        vbox.addWidget(self.activity_select)
        vbox.addWidget(activity_label_text)
        vbox.addWidget(self.activity_label)


        vbox.addStretch(1)
        groupBox.setLayout(vbox)

        return groupBox

    @pyqtSlot()
    def on_click_reset(self):
        print("reset")

    @pyqtSlot()
    def on_click_run(self):
        print("run")
        print(self.sitting.isChecked())
        self.roll2.setText("10")

        # prendiamo il attività selezionata
        if self.sitting.isChecked():
            self.activity_select.setText("sitting")
        elif self.sittingdown.isChecked():
            self.activity_select.setText("sittingdown")
        elif self.walking.isChecked():
            self.activity_select.setText("walking")
        elif self.standing.isChecked():
            self.activity_select.setText("standing")
        elif self.standingup.isChecked():
            self.activity_select.setText("standingup")

        print(self.activity_select.text())


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

        self.sitting = QRadioButton("Sitting")
        self.sittingdown = QRadioButton("Sittingdown")
        self.walking = QRadioButton("Walking")
        self.standing = QRadioButton("Standing")
        self.standingup = QRadioButton("Standingup")

        vbox = QVBoxLayout()
        vbox.addWidget(activity_text)
        vbox.addWidget(self.sitting)
        vbox.addWidget(self.sittingdown)
        vbox.addWidget(self.walking)
        vbox.addWidget(self.standing)
        vbox.addWidget(self.standingup)

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