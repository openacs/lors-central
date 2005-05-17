<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<include src="../form-md-record/md-record"
    ims_md_id="@ims_md_id;noquote@"/>

  <table cellspacing="2" cellpadding="2" border="0">
    <tr class="form-section">
      <th colspan="2">Relation Metadata</th>
    </tr>
    <tr class="form-section">
      <td class="form-section">Kind: </td>
      <td><listtemplate name= "d_re_kind"></listtemplate></td>
    </tr>
    <tr class="form-section">
      <th colspan="2">Relation Metadata Resource</th>
    </tr>	   
    <tr class="form-section">
      <td class="form-section">Identifier: </td>
      <td><listtemplate name= "d_re_ident"></listtemplate></td>
    </tr>
    <tr class="form-section">
      <td class="form-section">Description: </td>
      <td><listtemplate name= "d_re_desc"></listtemplate></td>
    </tr>
    <tr class="form-section">
      <td class="form-section">Catalog-Entries: </td>
      <td><listtemplate name= "d_re_cata"></listtemplate></td>
    </tr>
  </table>
