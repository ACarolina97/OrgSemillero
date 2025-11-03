/**
 * @description   LWC para listar y actualizar oportunidades relacionadas con una Cuenta.
 *                Permite al usuario editar el campo StageName mediante un modal interactivo.
 * @file          accountOpportunities.js
 * @author        Tu Nombre
 * @date          2025-11-02
 */


import { LightningElement, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountOpportunitiesController.getAccounts';
import getOpportunitiesByAccountId from '@salesforce/apex/AccountOpportunitiesController.getOpportunitiesByAccountId';
import updateOpportunityStage from '@salesforce/apex/AccountOpportunitiesController.updateOpportunityStage';
import getStageNamePicklistValues from '@salesforce/apex/AccountOpportunitiesController.getStageNamePicklistValues';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccountOpportunity extends LightningElement {
    @track accountOptions = [];
    @track selectedAccountId;
    @track opportunities;
    @track error;
    @track draftValues = [];
    @track stageOptions = [];

    columns = [];

    connectedCallback() {
        this.loadAccounts();
        this.loadStageValues();
    }

    /**
     * @description Carga las cuentas disponibles para el combobox.
     */
    loadAccounts() {
        getAccounts()
            .then(result => {
                this.accountOptions = result.map(acc => ({
                    label: acc.Name,
                    value: acc.Id
                }));
            })
            .catch(error => {
                this.error = error.body.message;
            });
    }

    /**
     * @description Carga los valores del picklist StageName.
     */
    loadStageValues() {
        getStageNamePicklistValues()
            .then(result => {
                this.stageOptions = result.map(stage => ({ label: stage, value: stage }));

                // Define columnas solo cuando tenemos el picklist
                this.columns = [
                    { label: 'Oportunidad', fieldName: 'Name', type: 'text' },
                    {
                        label: 'Etapa',
                        fieldName: 'StageName',
                        type: 'picklist',
                        editable: true,
                        typeAttributes: {
                            placeholder: 'Selecciona una etapa',
                            options: this.stageOptions,
                            value: { fieldName: 'StageName' },
                            context: { fieldName: 'Id' }
                        }
                    },
                    { label: 'Fecha Cierre', fieldName: 'CloseDate', type: 'date' },
                    { label: 'Monto', fieldName: 'Amount', type: 'currency' }
                ];
            })
            .catch(error => {
                console.error('Error al obtener etapas:', error);
            });
    }

    /**
     * @description Carga las oportunidades relacionadas a la cuenta seleccionada.
     */
    handleAccountChange(event) {
        this.selectedAccountId = event.detail.value;
        getOpportunitiesByAccountId({ accountId: this.selectedAccountId })
            .then(result => {
                this.opportunities = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error.body.message;
                this.opportunities = undefined;
            });
    }

    /**
     * @description Actualiza la etapa de una oportunidad desde el datatable.
     */
    handleSave(event) {
        const fields = event.detail.draftValues[0];
        updateOpportunityStage({ oppId: fields.Id, newStage: fields.StageName })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Éxito',
                        message: 'Etapa actualizada correctamente',
                        variant: 'success'
                    })
                );
                this.draftValues = [];
                this.handleAccountChange({ detail: { value: this.selectedAccountId } });
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}