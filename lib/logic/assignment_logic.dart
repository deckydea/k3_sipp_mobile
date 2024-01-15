import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/ui/main/assignment_page.dart';

class AssignmentLogic {
  final Map<AssignmentTabCategory, List<ExaminationStatus>> tabBarStatuses = {
    AssignmentTabCategory.pending: [
      ExaminationStatus.PENDING,
      ExaminationStatus.PENDING_APPROVE_QC1,
      ExaminationStatus.PENDING_APPROVE_QC2,
      ExaminationStatus.PENDING_INPUT_LAB,
    ],
    AssignmentTabCategory.revision: [
      ExaminationStatus.REVISION_QC1,
      ExaminationStatus.REVISION_QC2,
      ExaminationStatus.REVISION_INPUT_LAB,
    ],
    AssignmentTabCategory.signature: [
      ExaminationStatus.PENDING_SIGNED,
      ExaminationStatus.SIGNED,
      ExaminationStatus.REJECT_SIGNED,
    ],
    AssignmentTabCategory.completed: [
      ExaminationStatus.COMPLETED,
    ],
  };
}
