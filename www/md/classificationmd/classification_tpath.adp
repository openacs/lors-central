<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">Classification Metadata Taxonomic Path</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Source: </td>
      <td><listtemplate name= "d_cl_source"></listtemplate></td>
    </tr> 
    <tr class="form-section">
      <td class="form-section">Taxonomies: </td>
      <td><listtemplate name= "d_cl_taxon"></listtemplate></td>
    </tr>
  </table>
