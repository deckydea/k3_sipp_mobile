
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/examination/examination_type.dart';

class EnumTranslationUtils{

  static String examinationStatus(ExaminationStatus status) {
    switch (status) {
      case ExaminationStatus.PENDING:
        return "PENDING";
      case ExaminationStatus.REVISION_QC1:
        return "REVISI PETUGAS SAMPLING";
      case ExaminationStatus.PENDING_APPROVE_QC1:
        return "PENDING APPROVAL KOORDINATOR";
      case ExaminationStatus.REVISION_QC2:
        return "REVISI KOORDINATOR";
      case ExaminationStatus.PENDING_INPUT_LAB:
        return "PENDING INPUT LAB";
      case ExaminationStatus.REVISION_INPUT_LAB:
        return "REVISI INPUT LAB";
      case ExaminationStatus.PENDING_APPROVE_QC2:
        return "PENDING APPROVAL PENYELIA";
      case ExaminationStatus.REJECT_SIGNED:
        return "TANDATANGAN DITOLAK";
      case ExaminationStatus.PENDING_SIGNED:
        return "PENDING TANDATANGAN";
      case ExaminationStatus.SIGNED:
        return "DITANDATANGAN";
      case ExaminationStatus.COMPLETED:
        return "COMPLETED";
      default:
        return "-";
    }
  }

  static String examinationType(String type) {
    switch (type) {
      case ExaminationTypeName.kebisingan:
        return "Kebisingan Lingkungan Kerja";
      case ExaminationTypeName.penerangan:
        return "Penerangan";
      case ExaminationTypeName.iklimKerja:
        return "Iklim Kerja";
      case ExaminationTypeName.getaranLengan:
        return "Getaran Hand Arm";
      case ExaminationTypeName.getaranWholeBody:
        return "Getaran Whole Body";
      case ExaminationTypeName.sinarUV:
        return "Radiasi Ultra Violet";
      case ExaminationTypeName.gelombangElektroMagnet:
        return "Gelombang Mikro dan Magnet Statis";
      case ExaminationTypeName.kebisinganAmbient:
        return "Kebisingan Ambient";
      case ExaminationTypeName.kebisinganFrekuensi:
        return "Kebisingan Frekuensi";
      case ExaminationTypeName.noiseDose:
        return "Kebisingan Noise Dose";
      default:
        return "-";
    }
  }
}