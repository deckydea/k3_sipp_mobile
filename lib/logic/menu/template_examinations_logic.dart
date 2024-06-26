
import 'package:flutter/material.dart';
import 'package:k3_sipp_mobile/model/examination/examination_status.dart';
import 'package:k3_sipp_mobile/model/template/template.dart';
import 'package:k3_sipp_mobile/model/template/template_filter.dart';
import 'package:k3_sipp_mobile/net/master_message.dart';
import 'package:k3_sipp_mobile/net/request/template_request.dart';
import 'package:k3_sipp_mobile/repository/app_repository.dart';
import 'package:k3_sipp_mobile/ui/template/template_examinations_page.dart';
import 'package:k3_sipp_mobile/util/connection_utils.dart';

class TemplateExaminationsLogic {
  final Map<TemplateExaminationsTabCategory, List<ExaminationStatus>> tabBarStatuses = {
    TemplateExaminationsTabCategory.pending: [
      ExaminationStatus.PENDING,
      ExaminationStatus.PENDING_APPROVE_QC1,
      ExaminationStatus.PENDING_APPROVE_QC2,
      ExaminationStatus.PENDING_INPUT_LAB,
    ],
    TemplateExaminationsTabCategory.revision: [
      ExaminationStatus.REVISION_QC1,
      ExaminationStatus.REVISION_QC2,
      ExaminationStatus.REVISION_INPUT_LAB,
    ],
    TemplateExaminationsTabCategory.signature: [
      ExaminationStatus.PENDING_SIGNED,
      ExaminationStatus.SIGNED,
      ExaminationStatus.REJECT_SIGNED,
    ],
    TemplateExaminationsTabCategory.completed: [
      ExaminationStatus.COMPLETED,
    ],
  };

  final Set<ExaminationStatus> selectedStatuses = {};
  final List<Template> templates = [];
  final ScrollController scrollController = ScrollController();

  bool hasMore = true;
  bool loading = false;

  int maxQuerySize = 15;

  Future<MasterMessage> queryTemplates({required TemplateFilter filter}) async {
    String? token = await AppRepository().getToken();
    return await ConnectionUtils.sendRequest(
        QueryTemplatesRequest(token: token, filter: filter));
  }
}
